extends Control


func _ready() -> void:
	# warning-ignore:return_value_discarded
	Game.connect("state_changed", self, "_on_Game_state_changed")
	# warning-ignore:return_value_discarded
	Game.connect("score_changed", self, "_on_Game_score_changed")


func _on_Game_state_changed(state: int) -> void:
	if state == Game.State.GAME_OVER and Game.score > Config.best_score.value:
		# New high score!
		Config.best_score.value = Game.score

	visible = state in [Game.State.PLAYING, Game.State.GAME_OVER]
	$BestScoreLabel.visible = visible and Config.best_score.value > 0
	$BestScoreLabel.text = tr("BEST_N") % Config.best_score.value


func _on_Game_score_changed(score: int) -> void:
	$ScoreLabel.text = str(score)


func _on_PauseButton_pressed() -> void:
	if Game.state == Game.State.PLAYING:
		Game.pause()
