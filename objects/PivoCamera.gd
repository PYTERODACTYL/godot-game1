extends Node3D

var direcao = Vector3.FORWARD
@export_range (1,10,0.1) var smooth_speed: float = 2.5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocidade_atual = get_parent().get_linear_velocity()
	velocidade_atual.y = 0
	
	if velocidade_atual.length_squared() > 1:
		direcao = lerp(direcao, -velocidade_atual.normalized(),smooth_speed * delta)
	global_transform.basis = pegar_rotacao_da_direcao(direcao)
func pegar_rotacao_da_direcao(direcao_olhar : Vector3) -> Basis:
	direcao_olhar = direcao_olhar.normalized()
	var eixo_x = direcao_olhar.cross(Vector3.UP)
	return Basis(eixo_x, Vector3.UP, -direcao_olhar)
 
