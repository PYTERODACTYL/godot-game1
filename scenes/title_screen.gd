extends Node3D

@onready var tela_escura = $CanvasLayer/ColorRect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clarear_tela()
	$AudioStreamPlayer.play()
	pass # Replace with function body.

func clarear_tela():
	var tween = get_tree().create_tween()
	tween.tween_property(tela_escura, "modulate:a", 0.0, 4.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
