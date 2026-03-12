extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("body")
	get_tree().change_scene_to_file("res://scenes/hidden level1.tscn")
	
	
