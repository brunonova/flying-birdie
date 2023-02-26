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
