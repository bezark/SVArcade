extends Node2D
const SPEED = 30
var direction = 1

@onready var ray_cast_down: RayCast2D = $Sprite2D/RayCast_down
@onready var ray_cast_up: RayCast2D = $Sprite2D/RayCast_up
@onready var sprite_2d: Sprite2D = $Sprite2D

func _process(delta) :
	if ray_cast_down. is_colliding():
		direction = -1
		sprite_2d.flip_h = true
	if ray_cast_up. is_colliding():
		direction = 1
		sprite_2d.flip_h = false
	position.y += direction * SPEED * delta
