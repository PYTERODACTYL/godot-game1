extends Node3D

@onready var spawns = $Spawns
@onready var spawnsComida = $SpawnComida
@onready var navigation_region = $NavigationRegion3D
@onready var hud = $HUD
@onready var luz_garagem = $LuzGaragem
@onready var timer_final = $ChecaSeTemZumbisVivos
@onready var musica_tema = $AudioStreamPlayer

var zumbi = load("res://objects/zumbi.tscn")
var instance
var cafezinho = load("res://models/cafezinho.tscn")
var instanceCafezinho
var zumbis = 80
var zumbis_area = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)
	
func _on_zumbi_spawn_timer_timeout():
	
	if Audio.zumbis <= 0:
		pass
	else:
		var spawn_point = _get_random_child(spawns).global_position
		instance = zumbi.instantiate()
		instance.position = spawn_point
		instance.zumbi_morto.connect(hud._on_characterzombie_zumbi_morto)
		instance.visible = true
		navigation_region.add_child(instance)

func _on_cafezinho_timer_timeout():
	if Audio.max_cafezinhos == 2:
		pass
	else:
		var spawn_point_cafezinho = _get_random_child(spawnsComida).global_position
		instanceCafezinho = cafezinho.instantiate()
		instanceCafezinho.position = spawn_point_cafezinho
		instanceCafezinho.visible = true
		navigation_region.add_child(instanceCafezinho)
		Audio.max_cafezinhos += 1


func _on_area_limpar_zumbis_body_entered(body):
	if body.is_in_group("zumbi"):
		zumbis_area += 1
		Audio.zumbis_vivos += 1
		
	


func _on_area_limpar_zumbis_body_exited(body):
	if body.is_in_group("zumbi"):
		zumbis_area -= 1
		Audio.zumbis_vivos -= 1
		


func _on_checa_se_tem_zumbis_vivos_timeout():
	if Audio.zumbis <= 0 and Audio.zumbis_vivos == 0:
		Audio.play("res://sounds/garagem_liberada.ogg")
		luz_garagem.light_color = Color(0,177,0)
		timer_final.stop()
