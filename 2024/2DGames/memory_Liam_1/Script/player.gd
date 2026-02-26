extends CharacterBody2D
class_name Player

const SPEED = 100.0
var current_dir = "none"

func _physics_process(delta):
	player_movement(delta)
	

func player_movement(_delta):
	
	if Input.is_action_pressed("right"):
		current_dir = "right"
		play_anim(1) 
		velocity.x = SPEED
		velocity.y = 0
 
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		play_anim(1) 
		velocity.x = -SPEED
		velocity.y = 0
		
	elif Input.is_action_pressed("front"):
		current_dir = "down"
		play_anim(1) 
		velocity.y = SPEED
		velocity.x = 0
		
	elif Input.is_action_pressed("back"):
		current_dir = "up"
		play_anim(1) 
		velocity.y = -SPEED
		velocity.x = 0
		
	else:
		play_anim(0) 
		velocity.x = 0
		velocity.y = 0 
		
	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_Right")
		elif movement == 0:
			anim.play("idle_Right")
			
	if dir == "left":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_Left")
		elif movement == 0:
			anim.play("idle_Left")
			
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_Front")
		elif movement == 0:
			anim.play("idle_Front")
			
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_Back")
		elif movement == 0:
			anim.play("idle_Back")





func _on_area_2d_2_area_entered(area: Area2D) -> void:
	print("sss")
