extends Node

var score = 0
@onready var score_label: Label = $player_test/Camera2D/CanvasLayer/Score_Label

func add_point():
	score += 1
	print(score)
	$"../Player_test".updateScore(score)
