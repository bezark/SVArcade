extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("you died!")
	#Engine.time_scale =  0.5 (have bug)
	#body.get_node("CollisionShape2D").queue_free() 
	print(body)
	body.die()
	timer.start()
	

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
