extends Control


func _ready() -> void:
	# warning-ignore:return_value_discarded
	Game.connect("state_changed", self, "_on_Game_state_changed")
	# warning-ignore:return_value_discarded
	Config.connect("fullscreen_toggled", self, "_on_Config_fullscreen_toggled")
	$SoundButton.pressed = Config.sound.value
	$MusicButton.pressed = Config.music.value

	if OS.get_name() == "Android":
		# Hide fullscreen button on Android
		$FullscreenButton.visible = false
		$BirdColorButton.rect_position.x += 30
		$SoundButton.rect_position.x += 30
		$MusicButton.rect_position.x += 30
	elif OS.get_name() == "HTML5":
		# Remove exit button on the web
		$ExitButton.visible = false
		$FullscreenButton.pressed = false
	else:
		$FullscreenButton.pressed = Config.fullscreen.value


func _unhandled_input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("ui_cancel") and not OS.get_name() == "HTML5":
			get_tree().set_input_as_handled()
			get_tree().quit()


func _on_Game_state_changed(state: int) -> void:
	if state == Game.State.MAIN_MENU:
		# Show the main menu
		visible = true
		$PlayButton.grab_focus()
	else:
		# Hide the main menu
		visible = false


func _on_Config_fullscreen_toggled(fullscreen: bool) -> void:
	$FullscreenButton.pressed = fullscreen


func _on_PlayButton_pressed() -> void:
	Game.state = Game.State.PLAYING


func _on_ExitButton_pressed() -> void:
	get_tree().quit()


func _on_SoundButton_pressed() -> void:
	Config.sound.value = $SoundButton.pressed


func _on_MusicButton_pressed() -> void:
	Config.music.value = $MusicButton.pressed


func _on_FullscreenButton_pressed() -> void:
	if OS.get_name() == "HTML5":
		OS.window_fullscreen = not OS.window_fullscreen
	else:
		Config.fullscreen.value = $FullscreenButton.pressed


func _on_BirdColorButton_pressed() -> void:
	Config.bird_color.value = Config.BIRD_COLORS[(Config.BIRD_COLORS.find(Config.bird_color.value) + 1) % len(Config.BIRD_COLORS)]
