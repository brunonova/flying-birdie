extends Control


func _ready() -> void:
	# warning-ignore:return_value_discarded
	Game.connect("state_changed", self, "_on_Game_state_changed")
	# warning-ignore:return_value_discarded
	Config.connect("high_score", self, "_on_Config_high_score")


func _unhandled_input(event: InputEvent) -> void:
	if visible and $Buttons.visible:
		if event.is_action_pressed("ui_cancel"):
			get_tree().set_input_as_handled()
			Game.state = Game.State.MAIN_MENU


func _on_Game_state_changed(state: int) -> void:
	if state == Game.State.GAME_OVER:
		# Show the game over screen
		visible = true
		$Buttons.visible = false
		$ShowButtonsTimer.start()
		yield($ShowButtonsTimer, "timeout")  # wait for timer to finish
		$Buttons.visible = true
		$Buttons/RetryButton.grab_focus()
	else:
		# Hide the game over screen
		visible = false
		$AnimationPlayer.play("RESET")


func _on_Config_high_score(_score: int) -> void:
	$AnimationPlayer.play("high_score")


func _on_RetryButton_pressed() -> void:
	Game.state = Game.State.PLAYING


func _on_MenuButton_pressed() -> void:
	Game.state = Game.State.MAIN_MENU
