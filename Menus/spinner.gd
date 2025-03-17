extends MeshInstance3D

@export var speed = 0.01


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(speed)
