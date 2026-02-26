extends Area2D
@onready var current_level = get_tree().current_scene.name #Gets current scene cuh
@onready var game_manager: Node = get_parent().get_parent().get_node("Game manager")  # Access Game Manager
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D  # Access the AudioStreamPlayer2D
var is_collected = false

func _on_body_entered(_body):
	if not is_collected:
		if current_level == "Level1":
			audio_player = $AudioStreamPlayer2D2
		elif current_level == "Level2":
			audio_player = $AudioStreamPlayer2D
		elif current_level == "Level3":
			audio_player = $AudioStreamPlayer2D
		is_collected = true
		game_manager.add_point()  # Call the add_point function on the Game Manager
		audio_player.play()  # Play the sound associated with this coin
		hide()  # Optionally hide or remove the coin
