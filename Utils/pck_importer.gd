extends Node



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
