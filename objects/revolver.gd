extends Node3D
@onready var ray_cast_3d = $RayCast3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_3d.is_colliding():
		if ray_cast_3d.get_collider() == null:
			pass
		elif ray_cast_3d.get_collider().is_in_group("zumbi"):
			ray_cast_3d.get_collider().ta_na_mira()
