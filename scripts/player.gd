extends CharacterBody3D

@export_subgroup("Components")
@export var view: Node3D

@export_subgroup("Properties")
@export var movement_speed = 150
@export var jump_strength = 4

@onready var sons_cafezinho = $CafezinhoSons
@onready var sons_dano_livinha = $LivinhaDano
@onready var camera_mira = $CameraMirar

var movement_velocity: Vector3
var rotation_direction: float
var gravity = 0
var vida_livinha = 100.0
var balas = 6
var cafe = false
var tempo = 4.0
var recarregando = false
var dashes = 2
var mirando = false
var granadas = 3

signal livinha_dano
signal menos_bala
signal recarregando_state
signal recarregando_state_fim
signal efeito_cafe
signal efeito_cafe_passou

const HIT_STAGGER = 8.0

var previously_floored = false

var jump_single = true
var jump_double = true

var bala = load("res://objects/bala.tscn")
var granada = preload("res://objects/granada.tscn")
var pode_jogar_granada = true
var instance

@onready var sound_footsteps = $SoundFootsteps
@onready var model = $"character-skate-girl2/root"
@onready var animation = $AnimationPlayer
@onready var cano_revolver = $"character-skate-girl2/root/torso/arm-right/Revolver/RayCast3D"
@onready var h_box_container = $"../HUD/HBoxContainer"

# Functions

func _ready():
	for dash in dashes: 
		var investida = TextureRect.new()
		var caminho_textura = "res://sprites/progress_blueSmall.png"
		investida.texture = load("res://sprites/progress_blueSmall.png")
		h_box_container.add_child(investida)

func _physics_process(delta):
	
	# Handle functions
	
	handle_controls(delta)
	handle_gravity(delta)
	
	handle_effects()
	
	# Movement

	var applied_velocity: Vector3
	
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	
	velocity = applied_velocity
	
	if not mirando:
		move_and_slide()
	
	# Rotation
	
	if not mirando:  # Só altera a rotação se NÃO estiver mirando
		if Vector2(velocity.z, velocity.x).length() > 0:
			rotation_direction = Vector2(velocity.z, velocity.x).angle()
			rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)
	
	# Falling/respawning
	
	if position.y < -10:
		get_tree().reload_current_scene()
	
	# Animation for scale (jumping and landing)
	
	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 10)
	
	# Animation when landing
	
	if is_on_floor() and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.25, 0.75, 1.25)
		Audio.play("res://sounds/land.ogg")
	
	previously_floored = is_on_floor()
	
func _input(event):
	if mirando and event is InputEventMouseMotion:
		var sensibilidade = 0.002
		
		# Rotação horizontal do personagem
		rotation.y -= event.relative.x * sensibilidade
		
		# Inclinação vertical da câmera (limitada para não olhar muito para cima/baixo)
		view.rotation.x = clamp(view.rotation.x - event.relative.y * sensibilidade, deg_to_rad(-60), deg_to_rad(60))
# Handle animation(s)

func handle_effects():
	
	sound_footsteps.stream_paused = true
	
	if is_on_floor():
		if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			animation.play("walk", 0.5)
			sound_footsteps.stream_paused = false
		else:
			animation.play("holding-right", 1.5)
	else:
		animation.play("jump", 0.5)

# Handle movement input

func handle_controls(delta):
	
	# Movement
	
	var input := Vector3.ZERO
	
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	input = input.rotated(Vector3.UP, view.rotation.y).normalized()
	
	movement_velocity = input * movement_speed * delta
	
	if Input.is_action_just_pressed("dash") and dashes > 0 :
		dashes -= 1
		Audio.play("res://sounds/Cartoon-Dash-Sound-Effect-_-ezmp3.cc-_.ogg")
		var dash = h_box_container.get_child(0)
		h_box_container.remove_child(dash)
		dash.queue_free()
		movement_velocity = input * movement_speed * delta * 20
	
	# Jumping
	
	if Input.is_action_just_pressed("jump"):
		
		if jump_single:
			Audio.play("res://sounds/jump.ogg")
			
		if(jump_single): jump()
		
	
	if Input.is_action_just_pressed("atirar"):
		if recarregando:
			pass
		else:
			if balas == 0:
				recarregar()
			else:
				balas -= 1
				menos_bala.emit(balas)
				Audio.play("res://sounds/revolver.ogg")
				Audio.play("res://sounds/livinha_pa.ogg")
				animation.play("holding-right-shoot",-1)
				instance = bala.instantiate()
				instance.position = cano_revolver.global_position
				instance.transform.basis = cano_revolver.global_transform.basis
				get_parent().add_child(instance)
		
		
		
	if Input.is_action_just_pressed("katanada"):
		animation.play("katanada1")
		
	if Input.is_action_just_pressed("recarregar"):
		recarregar()
		
	if Input.is_action_just_pressed("mirar"):
		mirar()
		
	if Input.is_action_just_pressed("granada") && pode_jogar_granada:
		jogar_granada()

func jogar_granada():
		granadas -= 1
		match granadas:
			2:
				$"character-skate-girl2/root/torso/Grenade1".visible = false
			1:
				$"character-skate-girl2/root/torso/Grenade2".visible = false
			0:
				$"character-skate-girl2/root/torso/Grenade3".visible = false
		var granada_instancia = granada.instantiate()
		granada_instancia.position = $PosGranada.global_position
		get_tree().current_scene.add_child(granada_instancia)
		
		pode_jogar_granada = false
		$DescansoGranada.start()
		var forca_pra_frente = 5
		var forca_pra_cima = 1.5
		var direcao_jogador = $PosGranada.global_transform.basis.z.normalized()
		granada_instancia.apply_central_impulse((direcao_jogador * -forca_pra_frente) + Vector3(0,forca_pra_cima,0))
# Handle gravity
func mirar():
	mirando = !mirando
	camera_mira.current = mirando
	
	if mirando:
		Audio.play("res://sounds/Slow Motion Sound Effect.mp3")
		Engine.time_scale = 0.50
		await get_tree().create_timer(2.0).timeout
		Engine.time_scale = 1.00

func handle_gravity(delta):
	
	gravity += 25 * delta
	
	if gravity > 0 and is_on_floor():
		
		jump_single = true
		gravity = 0

# Jumping

func jump():
	
	gravity = -jump_strength
	
	model.scale = Vector3(0.5, 1.5, 0.5)
	
	jump_single = false;


func hit(dir):
	sons_dano_livinha.play()
	velocity += dir * HIT_STAGGER
	vida_livinha -= 25.0
	livinha_dano.emit(vida_livinha)
	
	if vida_livinha <= 0:
		Audio.zumbis = 50
		Audio.max_cafezinhos = 08
		Engine.time_scale = 0.25 
		await get_tree().create_timer(1.0).timeout
		Engine.time_scale = 1.00
		get_tree().reload_current_scene()
	
	
func recarregar():
	if balas == 6 or recarregando:
		return
		
	recarregando = true
	recarregando_state.emit()
	Audio.play("res://sounds/recarregar.ogg")
	if cafe:
		tempo = 2.0
	else:
		tempo = 4.0
	
	await get_tree().create_timer(tempo).timeout
	recarregando_state_fim.emit()
	recarregando = false
	balas = 6


func _on_hitbox_katana_body_entered(body):
	if body.has_method("katanada"):
		body.katanada(randf_range(4.5,9.0))

func cafezinho_tomado():
	Audio.max_cafezinhos -= 1
	sons_cafezinho.play()
	
	if vida_livinha <= 150:
		vida_livinha += 25.0
	
	if dashes <= 2:
		dashes += 1
		var investida = TextureRect.new()
		var caminho_textura = "res://sprites/progress_blueSmall.png"
		investida.texture = load("res://sprites/progress_blueSmall.png")
		h_box_container.add_child(investida)
	
	livinha_dano.emit(vida_livinha)
	movement_speed = 250
	cafe = true 
	efeito_cafe.emit()
	sound_footsteps.pitch_scale = 1.75
	await get_tree().create_timer(2.0).timeout
	sound_footsteps.pitch_scale = 1.25
	cafe = false
	efeito_cafe_passou.emit()
	movement_speed = 150
	


func _on_descanso_granada_timeout() -> void:
	if granadas != 0:
		pode_jogar_granada = true
