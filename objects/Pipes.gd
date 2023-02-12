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
