extends Control


func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/tutorial.tscn")


func _on_settings_pressed():
	print("Settings Pressed")


func _on_exit_pressed():
	get_tree().quit()
