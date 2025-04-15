extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_perdeu_body_entered(body):
	if body.is_in_group("impala"):
		Engine.time_scale = 0.25 
		await get_tree().create_timer(1.0).timeout
		Engine.time_scale = 1.00
		get_tree().reload_current_scene()


func _on_ganhou_body_entered(body):
	if body.is_in_group("impala"):
		Engine.time_scale = 0.25 
