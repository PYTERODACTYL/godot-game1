extends Node3D

const VELOCIDADE = 30.0

signal zumbi_baleado

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D	
@onready var sangue = $Sangue
@onready var impacto = $Impacto

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.basis * Vector3(0, 0, -VELOCIDADE) * delta
	if ray.is_colliding():
		mesh.visible = false
		if ray.get_collider().is_in_group("zumbi"):
			ray.get_collider().dano_revolver()
			sangue.emitting = true
			Audio.play("res://sounds/impacto_zumbi.ogg")
			await get_tree().create_timer(1.0).timeout
			queue_free()
		else:
			impacto.emitting = true
			await get_tree().create_timer(1.0).timeout
			queue_free()
			



func _on_timer_timeout():
	queue_free()
