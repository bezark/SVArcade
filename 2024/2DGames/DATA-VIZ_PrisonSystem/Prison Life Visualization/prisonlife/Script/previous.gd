extends Area2D
@export var previousLevel: PackedScene


func _on_body_entered(body: Node2D) -> void:
	print ("previous")
	get_tree().change_scene_to_packed(previousLevel)
