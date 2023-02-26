# Copyright (C) 2023  Bruno Nova
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
