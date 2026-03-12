extends Node2D


@export var dialogue: Array[String]

var which_line = 0

const MEMORY = preload("res://Scene/memory.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#print(dialogue)
	#print(dialogue[0])
	#print(dialogue[1])
	#print(dialogue[2])
	#print(dialogue[3])
	#print(dialogue[4])
	#print(dialogue[5])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") and playernearby: 
		which_line += 1
		
		if which_line >= dialogue.size():
			$DialogueBox.hide()
			which_line = 0
			var memory = MEMORY.instantiate()
			
			
			add_child(memory)
			memory.position = $Memory11.position
			
		else:
			print(dialogue)
			$DialogueBox/PanelContainer/Text.text = dialogue[which_line]
			


# 当玩家进入碰撞区域时触发

var playernearby = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$DialogueBox.show()
		playernearby = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$DialogueBox.hide()
		playernearby = false
