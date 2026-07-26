extends Node

func _ready() -> void:
	$AudioStreamPlayer.connect("finished", $AudioStreamPlayer.play)
