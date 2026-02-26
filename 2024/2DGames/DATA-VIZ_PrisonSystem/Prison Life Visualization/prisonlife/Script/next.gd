extends Area2D
@export var nextLevel: PackedScene


func _on_body_entered(body: Node2D) -> void:
	print ("next")
	get_tree().change_scene_to_packed(nextLevel)
