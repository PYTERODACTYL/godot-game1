extends Node3D

@onready var cascalho = $Cascalho
@onready var fumaca = $Fumaca
@onready var fogo = $Fogo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cascalho.emitting = true
	fumaca.emitting = true
	fogo.emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()
