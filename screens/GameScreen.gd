class_name GameScreen
extends Node

export(PackedScene) var pipes_scene: PackedScene
export(float, 0, 1000) var pipes_y_variation := 200.0
export(float, 0, 1000) var pipes_x_offset := 200.0


func _ready() -> void:
	# warning-ignore:return_value_discarded
	Game.connect("state_changed", self, "_on_Game_state_changed")
	Game.state = Game.State.MAIN_MENU  # Opens the main menu


func _process(delta: float) -> void:
	if Game.state != Game.State.GAME_OVER:
		$ParallaxBackground.scroll_offset.x -= Game.pipes_speed * delta
		$ParallaxGround.scroll_offset.x -= Game.pipes_speed * delta


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and Game.state == Game.State.PLAYING:
		get_tree().set_input_as_handled()
		Game.pause()


func _on_Game_state_changed(state: int) -> void:
	get_tree().paused = false
	match state:
		Game.State.MAIN_MENU:
			remove_pipes()
			$PipeSpawnTimer.stop()
			$Music.stop()

		Game.State.PLAYING:
			remove_pipes()
			$PipeSpawnTimer.start()
			$Music.play()
			spawn_pipes()
			Game.score = 0

		Game.State.GAME_OVER:
			$Music.stop()
			$PipeSpawnTimer.stop()


func _on_PipeSpawnTimer_timeout() -> void:
	spawn_pipes()


func spawn_pipes() -> void:
	var viewport_size := get_viewport().get_visible_rect().size

	var pipes: Pipes = pipes_scene.instance()
	pipes.position = Vector2(viewport_size.x + pipes_x_offset, viewport_size.y / 2)
	pipes.position.y += rand_range(-pipes_y_variation, pipes_y_variation)
	$Pipes.add_child(pipes)


func remove_pipes() -> void:
	for child in $Pipes.get_children():
		(child as Node).queue_free()
