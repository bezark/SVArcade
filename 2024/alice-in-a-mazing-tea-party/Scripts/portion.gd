extends Node3D
@onready var potion_sound =$Potion_Sound # AudioStreamPlayerノードを参照


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		potion_sound.play()
		body.pick()
		queue_free()
