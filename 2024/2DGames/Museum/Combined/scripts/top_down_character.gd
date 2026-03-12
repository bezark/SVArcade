extends CharacterBody2D

@export var move_speed : float = 100  # speed in pixels/sec

func _physics_process(delta):
	var input_direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	velocity = input_direction * move_speed
	
	$AnimationTree.set("parameters/walk/blend_position", velocity)
		
	
	move_and_slide()
