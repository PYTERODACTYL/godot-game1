extends Node3D

@export_group("Properties")
@export var target: Node

@export_group("Zoom")
@export var zoom_minimum = 10
@export var zoom_maximum = 0
@export var zoom_speed = 10

@export_group("Rotation")
@export var rotation_speed = 0.1  # Diminua este valor para reduzir a velocidade de rotação

var camera_rotation: Vector3
var zoom = 4

@onready var camera = $SpringArm3D/Camera3D

func _ready():
	camera_rotation = rotation_degrees # Initial rotation
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Captura o mouse para que ele não saia da janela

func _physics_process(delta):
	# Set position and rotation to targets
	self.position = self.position.lerp(target.position, delta * 4)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	camera.position = camera.position.lerp(Vector3(0, 0, zoom), 8 * delta)

	handle_input(delta)

func handle_input(delta):
	# Captura o movimento do mouse para a rotação
	var mouse_motion: Vector2 = Input.get_last_mouse_velocity()

	# Aplica o movimento do mouse à rotação da câmera com um fator menor para suavizar
	camera_rotation.x -= mouse_motion.y * rotation_speed * delta
	camera_rotation.y -= mouse_motion.x * rotation_speed * delta
	camera_rotation.x = clamp(camera_rotation.x, -80, -10)
	
	# Zoom
	zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
	zoom = clamp(zoom, zoom_maximum, zoom_minimum)
