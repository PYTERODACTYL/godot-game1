extends VehicleBody3D

const MAX_STEER = 0.8
const ENGINE_POWER = 800


@onready var camera_pivo = $PivoCamera
@onready var camera = $PivoCamera/Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	steering = move_toward(steering,Input.get_axis("move_right", "move_left") * MAX_STEER,delta * 2.5)
	engine_force = Input.get_axis("move_back", "move_forward") * ENGINE_POWER
