extends Node


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#load_pck()

#
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("jump"):
		#load_pck("res://PCKs/Prison.pck", "res://Scene/mainLevel.tscn/", null)
	#elif Input.is_action_just_pressed("attack"):
		#load_pck("res://PCKs/Echo.pck", "res://scenes/levels/Opening_Menu.tscn", null)


func load_pck(path, main, globals):
	# This could fail if, for example, mod.pck cannot be found.
	var success = ProjectSettings.load_resource_pack(path)
	# var success = ProjectSettings.load_resource_pack("res://Prison.pck")

	if success:
		# Now one can use the assets as if they had them in the project from the start.
		# var imported_scene = load("res://Scene/mainLevel.tscn/")
		var imported_scene = load(main)
		Metagame.load_game(imported_scene)
		if globals:
			Metagame.load_globals(globals)
