extends CharacterBody3D


var livinha = null
var state_machine 
var vida = 9.0
var mirado = false
signal zumbi_morto

var SPEED = randf_range(1.5,2.5)
const ATTACK_RANGE = 0.4

var sangue_chao = load("res://scenes/sangue_chao.tscn")
var pedacos_zumbi = {
	"cabwca": load("res://models/zumbi/cabeca.tscn"),
	"tronco": load("res://models/zumbi/tronco.tscn"),
	"braco_direito": load("res://models/zumbi/braco_direito.tscn"),
	"braco_esquerdo": load("res://models/zumbi/braco_esquerdo.tscn"),
	"perna_direita": load("res://models/zumbi/perna_direita.tscn"),
	"perna_esquerda": load("res://models/zumbi/perna_esquerda.tscn")
}

@export var livinha_caminho := "/root/Main/Player"

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree
@onready var sangue = $Sangue
@onready var sons_morte = $SonsMorte
@onready var sons_machucado = $SonsMachucado
@onready var mira = $Mira
@onready var verifica_se_ainda_ta_mirado = $VerificaSeAindaTaMirado
@onready var raycast_sangue = $RayCastSangue
@onready var posica_sangue = $PosicaoSangue

func _ready():
	livinha = get_node(livinha_caminho)
	state_machine = anim_tree.get("parameters/playback")
	
func _process(delta):
	verifica_se_ta_na_mira()
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"walk":
			# Navigation
			nav_agent.set_target_position(livinha.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
		"emote-yes":
			look_at(Vector3(livinha.global_position.x, global_position.y, livinha.global_position.z), Vector3.UP)
	
	anim_tree.set("parameters/conditions/attack", _alvo_em_alcance())
	anim_tree.set("parameters/conditions/run", !_alvo_em_alcance())
	
	move_and_slide()

func verifica_se_ta_na_mira():
	if mirado:
		mira.visible = true
	else:
		mira.visible = false


func ta_na_mira():
	mirado = true
	verifica_se_ainda_ta_mirado.start()
	
func _alvo_em_alcance():
	return global_position.distance_to(livinha.global_position) < ATTACK_RANGE
	
func _ataque_finalizado():
	if global_position.distance_to(livinha.global_position) < ATTACK_RANGE + 1.0:
		var dir = global_position.direction_to(livinha.global_position)
		livinha.hit(dir)

func criar_sangue():
	var decal = sangue_chao.instantiate()
	decal.rotation_degrees = Vector3(0, randf() * 360, 0) 
	get_parent().add_child(decal)
	decal.global_transform.origin = posica_sangue.global_transform.origin

func katanada(dano):
	Audio.play("res://sounds/impacto_katana.ogg")
	vida -= dano
	sangue.emitting = true
	criar_sangue()  # Adiciona o sangue no chão

	if vida <= 0:
		morrer()
	else:
		sons_machucado.play()

func _on_area_3d_zumbi_baleado():
	vida -= randf_range(3.0,9.0)
	criar_sangue()  # Adiciona o sangue no chão

	if vida <= 0:
		morrer()
	else:
		sons_machucado.play()

func dano_revolver():
	vida -= randf_range(3.0,9.0)
	criar_sangue()  # Adiciona o sangue no chão

	if vida <= 0:
		morrer()
	else:
		sons_machucado.play()

func dano_granada(granada):
	visible = false
	var pos_explosao = global_transform.origin  
	for nome in pedacos_zumbi:
		instanciar_pedaco(nome, pos_explosao, granada)
	morrer()

func instanciar_pedaco(nome, pos, granada):
	if nome in pedacos_zumbi:
		var pedaco = pedacos_zumbi[nome].instantiate()
		get_parent().add_child(pedaco)
		
		# Define a posição inicial no local da explosão
		pedaco.global_transform.origin = pos
		pedaco.explodir(granada.global_transform.origin)

func morrer():
	Audio.zumbis -= 1
	zumbi_morto.emit()
	sons_morte.play()
	anim_tree.set("parameters/conditions/die", true)
	set_collision_layer_value(1, false)
	await get_tree().create_timer(4.0).timeout
	queue_free()

func _on_verifica_se_ainda_ta_mirado_timeout():
	mirado = false
