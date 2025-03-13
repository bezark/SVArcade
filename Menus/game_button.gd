extends TextureButton
class_name GameButton
@export var game_data : GameInfo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	if game_data.thumbnail:
		$HBox/Thumbnail.texture = game_data.thumbnail
	
	$HBox/VBox/Authors.text = game_data.authors
	$HBox/VBox/Title.text = game_data.title




func _on_button_down() -> void:
	$PCKImporter.load_pck(game_data.pck_file, game_data.main_scene, game_data.globals)




func _on_focus_entered() -> void:
	$Move.play()
	
