extends Control


func _ready() -> void:
	# warning-ignore:return_value_discarded
	Game.connect("paused", self, "_on_Game_paused")


func _unhandled_input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("ui_cancel"):
			get_tree().set_input_as_handled()
			unpause()


func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT and not get_tree().paused and Game.state == Game.State.PLAYING:
		# Game lost focus, so pause the game
		_on_Game_paused()


func _on_Game_paused() -> void:
	pause()


func _on_YesButton_pressed() -> void:
	get_tree().paused = false
	visible = false
	Game.state = Game.State.MAIN_MENU


func _on_NoButton_pressed() -> void:
	unpause()


func pause() -> void:
	visible = true
	$YesButton.grab_focus()
	get_tree().paused = true


func unpause() -> void:
	visible = false
	get_tree().paused = false
