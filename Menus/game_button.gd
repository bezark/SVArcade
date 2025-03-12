extends Button
class_name GameButton
@export var game_data : GameInfo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grab_focus()
	grab_click_focus()
	
	
	
	if game_data.thumbnail:
		$Thumbnail.texture = game_data.thumbnail
	text = game_data.title





func _on_button_down() -> void:
	$PCKImporter.load_pck(game_data.pck_file, game_data.main_scene, game_data.globals)
