extends Control
class_name MainMenu


@onready var start_buttom = $MarginContainer/HBoxContainer/VBoxContainer/Start_Buttom as Button
@onready var start_level = preload("res://Scene/CC_Scene_/Homee.tscn") as PackedScene

func _ready():
	start_buttom.button_down.connect(on_start_press)


func on_start_press()-> void:
	get_tree().change_scene_to_packed(start_level)
