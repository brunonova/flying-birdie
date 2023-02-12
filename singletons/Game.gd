extends Node

signal score_changed(score)
signal state_changed(state)
signal paused

enum State {MAIN_MENU, PLAYING, GAME_OVER}

export(float, 0, 1000) var pipes_speed := 200.0

var state: int = State.MAIN_MENU setget _set_state, _get_state
var score := 0 setget _set_score, _get_score


func _ready() -> void:
	randomize()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		get_tree().set_input_as_handled()
		if OS.get_name() == "HTML5":
			OS.window_fullscreen = not OS.window_fullscreen
		else:
			Config.fullscreen.value = not Config.fullscreen.value


func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		# Back button on Android pressed
		match self.state:
			State.PLAYING:
				var nodes = get_tree().get_nodes_in_group("pause")
				if len(nodes) > 0:
					var pause_screen = nodes[0]
					if get_tree().paused:
						# Game paused: exit to menu
						pause_screen.unpause()
						self.state = State.MAIN_MENU
					else:
						# Playing: pause the game
						pause_screen.pause()
			State.GAME_OVER:
				self.state = State.MAIN_MENU
			State.MAIN_MENU:
				get_tree().quit()


func pause() -> void:
	emit_signal("paused")


func _set_state(val: int) -> void:
	state = val
	emit_signal("state_changed", state)

func _get_state() -> int:
	return state


func _set_score(val: int) -> void:
	score = val
	emit_signal("score_changed", score)

func _get_score() -> int:
	return score
