extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -380.0
@onready var animation: AnimatedSprite2D = $animation


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction =-1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	#flip the sprite
	if direction > 0 :
		animation.flip_h = false
	elif direction < 0:
		animation.flip_h = true
	
	# play animation
	if is_on_floor():
		if direction == 0 :
			animation.play("idle")
		else:
			animation.play("walk")
	else:
		animation.play("idle")

		
	
	# apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func updateScore(newScore):
	$Camera2D/CanvasLayer/Score_Label.text = str(newScore)+" / 15"
