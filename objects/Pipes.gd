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

class_name Pipes
extends Node2D


func _process(delta: float) -> void:
	if Game.state != Game.State.GAME_OVER:
		position.x -= Game.pipes_speed * delta


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_ScoreArea_body_entered(body: Node) -> void:
	if body.is_in_group("bird") and Game.state == Game.State.PLAYING:
		Game.score += 1
		$ScoreSound.play()
