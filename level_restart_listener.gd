extends Node

func _ready() -> void:
	$AudioStreamPlayer.connect("finished", $AudioStreamPlayer.play)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart_level"):
		get_tree().call_deferred("reload_current_scene")
