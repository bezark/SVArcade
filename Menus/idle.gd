extends Node2D

var landed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton and landed and not event.pressed:
		print(event)
		get_tree().change_scene_to_file("res://Menus/main_menu.tscn")


func _on_timer_timeout() -> void:
	landed = true
	pass # Replace with function body.
