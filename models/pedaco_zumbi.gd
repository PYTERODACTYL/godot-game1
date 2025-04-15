extends RigidBody3D

var forca = 900
var sangue_chao = load("res://scenes/sangue_chao.tscn")
@onready var posicao_sangue = $PosicaoSangue

func _ready() -> void:
	rotation_degrees.y = randf() * 360
	rotation_degrees.x = randf_range(-15, 15)
	rotation_degrees.z = randf_range(-15, 15)
	
	await get_tree().create_timer(4.0).timeout
	queue_free()

func explodir(fonte):
	apply_central_force((global_transform.origin - fonte).normalized() * forca)
	
func criar_sangue():
	var decal = sangue_chao.instantiate()
	decal.rotation_degrees = Vector3(0, randf() * 360, 0) 
	get_parent().add_child(decal)

	# Pegamos a posição central do pedaço
	var origem = global_transform.origin + Vector3(0, 0.5, 0)  # Levanta um pouco para evitar colisão própria
	var destino = origem - Vector3(0, 10, 0)  # Agora verifica uma área maior para encontrar o chão

	# Configura o RayCast
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(origem, destino)
	query.collide_with_areas = true  # Se o chão for uma área, ativa isso
	query.exclude = [self]  # Evita colisão com o próprio pedaço do zumbi

	var resultado = space_state.intersect_ray(query)

	if resultado:
		decal.global_transform.origin = resultado.position  # Posiciona exatamente no chão detectado
	else:
		decal.global_transform.origin = global_transform.origin  # Se falhar, coloca na posição do pedaço mesmo

func _on_spawn_sangue_timeout() -> void:
	criar_sangue()
