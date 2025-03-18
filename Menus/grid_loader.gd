extends GridContainer
@export var class_projects : ClassProjects
@export var game_ui : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	#grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Metagame.start_music()
	var old_ui = null
	for game in class_projects.projects:
		var new_ui : GameButton = game_ui.instantiate()
		new_ui.game_data = game
		
		add_child(new_ui)
		if old_ui:
			new_ui.focus_previous = old_ui.get_path()
		old_ui = new_ui


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
