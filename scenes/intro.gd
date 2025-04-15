extends Control

@onready var texture_rect = $TextureRect
@onready var texture_rect2 = $TextureRect2
@onready var tween = create_tween()

func _ready():
	texture_rect.modulate.a = 0.0
	texture_rect2.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(texture_rect, "modulate:a", 1.0, 2.0)
	await tween.finished
	await get_tree().create_timer(2).timeout # espera 2 segundos
	escurecer()
	await get_tree().create_timer(2).timeout
	var tween2 = create_tween()
	tween2.tween_property(texture_rect2, "modulate:a", 1.0, 2.0)
	await tween2.finished
	await get_tree().create_timer(4).timeout 
	escurecer2()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
func escurecer():
	var tween = create_tween()
	tween.tween_property(texture_rect, "modulate:a", 0.0, 2.0) # 2 segundos pra escurecer

func escurecer2():
	var tween = create_tween()
	tween.tween_property(texture_rect2, "modulate:a", 0.0, 2.0) # 2
func _process(delta: float) -> void:
	pass
