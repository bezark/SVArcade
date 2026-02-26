extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -380.0
const PUSH_FORCE = 100
const MAX_VELOCITY = 150

@onready var animation: AnimatedSprite2D = $animation
@export var nextLevel: PackedScene
@onready var current_level = get_tree().current_scene.name	
var is_alive = true
var is_dying = false
var is_ending = false
var is_attacking = false


func die():
	animation.play("die")	
	is_alive = false
		
# attack
func attack():
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		if current_level == "Level1":
			animation.play("attack_guitar")
			await animation.animation_finished
			is_attacking = false
		elif current_level == "Level2":
			animation.play("attack_flute")
			await animation.animation_finished
			is_attacking = false
		elif current_level == "Level3":
			animation.play("attack_piano")
			await animation.animation_finished
			is_attacking = false


func _physics_process(delta: float) -> void:
	if is_dying:
		return
	
	if is_ending:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction =-1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Attack
	if Input.is_action_just_pressed("attack"):
		attack()

		
	#flip the sprite
	if direction > 0 :
		animation.flip_h = false
	elif direction < 0:
		animation.flip_h = true
		
	# play animation
	if is_dying:
		return
	if is_attacking:
		return
		
	if is_on_floor():
		if direction == 0 :
			if is_alive:
				animation.play("idle")
		else:
			if is_alive:
				animation.play("walk")
	else:
		if is_alive:
			animation.play("jump")
	
	
	# apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()	
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_pushbox = collision.get_collider()
		if collision_pushbox:
			if collision_pushbox.is_in_group("pushboxes") and abs(collision_pushbox.get_linear_velocity().x) < MAX_VELOCITY:
				collision_pushbox.apply_central_impulse(collision.get_normal() * -PUSH_FORCE)
 

	
	
# win zone
func endLevel() -> void:
	is_ending = true
	if current_level == "Level1":
		animation.play("guitar")
	elif current_level == "Level2":
		animation.play("flute")
	elif current_level == "Level3":
		animation.play("piano")	
		
func updateScore(newScore):
	$Camera2D/CanvasLayer/Score_Label.text = str(newScore)+" / 15"
