extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -500.0

var jumping = false

@onready var  animated_sprite_2d = get_node("AnimatedSprite2D")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var direction := Input.get_axis("left", "right")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animated_sprite_2d.play("jump")
		jumping = true
		velocity.y = JUMP_VELOCITY
	if direction == 1:
		animated_sprite_2d.flip_h = true
	#else:
		#animated_sprite_2d.flip_h = false

	if velocity.y == 0 :
		jumping = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		if not jumping:
			animated_sprite_2d.play("run")
		velocity.x = direction * SPEED
		if direction == 1:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not jumping:
			animated_sprite_2d.play("default")
		

	move_and_slide()
