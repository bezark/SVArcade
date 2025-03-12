extends Node



func load_game(packed_game_tscn:PackedScene):
	remove_children()
	prints("loading", packed_game_tscn)
	var new_scene = packed_game_tscn.instantiate()
	#get_tree().root.add_child(new_scene)
	get_tree().change_scene_to_packed(packed_game_tscn)
	
	await get_tree().process_frame
	print(get_tree().root.get_children())
	var button = find_first_button(get_tree().get_root())
	#print(get_tree().get_root())
	print(button)
	if button:
		button.grab_focus.call_deferred()
	
func remove_children():
	var children = get_children()
	for dead_child in children:
		dead_child.queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_file("res://main.tscn")
		remove_children()

		
func find_first_button(node: Node) -> Button:
	#print(node.get_children())
	if node is Button:
		return node
	for child in node.get_children():
		# Ensure that the child is actually a Node (in case of non-Node items)
		if child is Node:
			var found = find_first_button(child)
			if found:
				return found
	return null


func load_globals(globals):
	remove_children()
	for global in globals:
		pass
		var new_global = load(global).instantiate()
		add_child(new_global)
