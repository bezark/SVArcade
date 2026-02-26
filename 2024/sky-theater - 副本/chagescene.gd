extends Area2D


var entered = false

func _on_body_entered(body: PhysicsBody2D):
	entered = true
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://scene2.tscn")

func _on_body_exited(body: PhysicsBody2D):
	entered = false
	
		
