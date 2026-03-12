extends Control

@onready var start_level = preload("res://Scene/CC_Scene_/Homee.tscn") as PackedScene





func _on_start_buttom_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
