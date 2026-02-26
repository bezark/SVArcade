extends StaticBody2D


var player_near = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	player_near = true
	print("press E to break the box")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("attack") and player_near:
		queue_free()
