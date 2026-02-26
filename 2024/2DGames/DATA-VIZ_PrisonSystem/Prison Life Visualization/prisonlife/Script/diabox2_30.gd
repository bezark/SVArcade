extends Node2D
@export var dialogue: Array[String]
var which_line = 0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and playernearby:
		
		which_line += 1
		
		if which_line >= dialogue.size():
			$diabox.hide()
			which_line = 0
			print(which_line)
		else:
			print(dialogue)
			$diabox/PanelContainer/text.text = dialogue[which_line]

var playernearby = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	playernearby = true
	$diabox.show()
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	playernearby = false
	$diabox.hide()
