extends Node
var button_timer : Timer 
var idle_watch = false

func _ready() -> void:
	get_tree().node_added.connect(focus_button)
	$Music.play()
	idle_watch = false



func load_game(packed_game_tscn:PackedScene):
	remove_children()
	prints("loading", packed_game_tscn)
	var new_scene = packed_game_tscn.instantiate()
	#get_tree().root.add_child(new_scene)
	get_tree().change_scene_to_packed(packed_game_tscn)
	idle_watch = true
	$Music.stop()
	

func focus_button(node):

	if node is Button or node is TextureButton:
		node.grab_click_focus()
		node.grab_focus()


func remove_children():
	var children = get_children()
	for dead_child in children:
		if not dead_child.is_in_group("meta"):
			dead_child.queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
		$Music.play()
		hide_continue()
		idle_watch = false
		remove_children()

		

func load_globals(globals):
	remove_children()
	for global in globals:
		pass
		var new_global = load(global).instantiate()
		add_child(new_global)


func _input(event: InputEvent) -> void:
	print(event)
	if idle_watch:
		$IdleTimer.start()
	hide_continue()

func hide_continue():
	$StillPlaying.hide()
	seconds_left = 10
	$StillPlaying/Timer.stop()
	
var seconds_left = 10

##Start countdown
func _on_timer_timeout() -> void:
	print("timeou")
	$StillPlaying/PanelContainer/CenterContainer/VBoxContainer/Countdown.text = str(seconds_left)
	$AnimationPlayer.play("stillplaying?")
	$StillPlaying.show()


func _on_seconds_timer_timeout() -> void:
	seconds_left -= 1
	$StillPlaying/PanelContainer/CenterContainer/VBoxContainer/Countdown.text = str(seconds_left)
	if seconds_left <= 0:
		hide_continue()
		get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
		$Music.play()
		remove_children()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "stillplaying?":
		$StillPlaying/Timer.start()


func start_music():
	if not $Music.playing:
		$Music.play()

func stop_music():
	$Music.stop()
