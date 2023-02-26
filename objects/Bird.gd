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

class_name Bird
extends RigidBody2D

export(float, 0, 2000) var flap_strength := 500.0
export(float, 1, 100) var rotation_divisor := 20.0

var reset_position := true
onready var original_position := position
onready var original_gravity := gravity_scale


func _ready() -> void:
	# warning-ignore:return_value_discarded
	Game.connect("state_changed", self, "_on_Game_state_changed")
	# warning-ignore:return_value_discarded
	Config.connect("bird_color_changed", self, "_on_Config_game_color_changed")
	gravity_scale = 0


func _process(_delta: float) -> void:
	var rotation_factor := 0.3 if Game.state == Game.State.GAME_OVER else 1.0
	rotation_degrees = clamp(linear_velocity.y / (rotation_divisor * rotation_factor), -90, 90)


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if reset_position:
		reset_position = false
		state.transform = Transform2D(0, original_position)


func _unhandled_input(event: InputEvent) -> void:
	if Game.state == Game.State.PLAYING:
		if event.is_action_pressed("flap"):
			flap()


func _on_Game_state_changed(state: int) -> void:
	match state:
		Game.State.MAIN_MENU:
			reset_position = true
			gravity_scale = 0
			linear_velocity = Vector2.ZERO
			$AnimatedSprite.play("idle_" + Config.bird_color.value)
		Game.State.PLAYING:
			reset_position = true
			gravity_scale = original_gravity
			linear_velocity = Vector2.ZERO
			flap()


func _on_Config_game_color_changed(bird_color: String) -> void:
	var current_frame = $AnimatedSprite.frame
	$AnimatedSprite.play("idle_" + bird_color)
	$AnimatedSprite.frame = current_frame


func _on_AnimatedSprite_animation_finished() -> void:
	if Game.state == Game.State.PLAYING:
		if $AnimatedSprite.animation.begins_with("flap"):
			$AnimatedSprite.play("fly_" + Config.bird_color.value)


func _on_Bird_body_entered(body: Node) -> void:
	if Game.state == Game.State.PLAYING:
		if body.is_in_group("environment"):
			$HitSound.play()
			if linear_velocity.y < 0:
				linear_velocity.y = 0
			Game.state = Game.State.GAME_OVER


func flap() -> void:
	linear_velocity = Vector2(0, -flap_strength)
	$FlapSound.play()
	$AnimatedSprite.play("flap_" + Config.bird_color.value)
	$AnimatedSprite.frame = 0
