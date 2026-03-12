extends Area2D
@export var nextLevel: PackedScene
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var current_level = get_tree().current_scene.name #Gets current scene cuh
func _on_body_entered(_body: Node2D) -> void:
	var ending_song_timer
	if current_level == "Level1":
		ending_song_timer = 10
		audio_player = $Guitar_Song
	elif current_level == "Level2":
		ending_song_timer = 14
		audio_player = $Flute_Song
	elif current_level == "Level3":
		ending_song_timer = 10
		audio_player = $Piano_Song
	print ("you win")
	audio_player.play()
	_body.endLevel()
	await get_tree().create_timer(ending_song_timer).timeout 
	get_tree().change_scene_to_packed(nextLevel)
