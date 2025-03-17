extends CanvasLayer
var game_data : GameInfo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Title.text = game_data.title
	%Authors.text = game_data.authors
	$PanelContainer/CenterContainer/VBoxContainer/Play.grab_click_focus()


func _on_play_button_down() -> void:
	$PCKImporter.load_pck(game_data.pck_file, game_data.main_scene, game_data.globals)
	
