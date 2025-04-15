extends RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _on_body_entered(body: Node) -> void:
	linear_damp = 0.3
	angular_damp = 1.5


func _on_pavio_timeout() -> void:
	$Pavio.stop()
	$MeshGranada.visible = false
	$SomExplosao.play()
	$Fogo.emitting = true
	$Fumaca.emitting = true
	$Cascalho.emitting = true
	var pegos_no_raio_de_explosao = $RaioExplosao.get_overlapping_bodies()
	for pego in pegos_no_raio_de_explosao:
		if pego.is_in_group("zumbi") && pego.has_method("dano_granada"):
			pego.dano_granada(self)
			
	await get_tree().create_timer(2.0).timeout
	queue_free()
