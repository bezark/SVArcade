extends TextureButton
class_name GameButton
@export var game_data : GameInfo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	if game_data.thumbnail:
		$HBox/Thumbnail.texture = game_data.thumbnail
	
	$HBox/VBox/Authors.text = game_data.authors
	$HBox/VBox/Title.text = game_data.title



const CONTEXT = preload("res://Menus/context.tscn")
func _on_button_down() -> void:
	var new_context = CONTEXT.instantiate()
	new_context.game_data = game_data
	add_child(new_context)
	




func _on_focus_entered() -> void:
	$Move.play()
	
