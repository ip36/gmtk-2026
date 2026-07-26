extends Area2D

func _ready() -> void:
	connect("body_entered", kill)

func kill(who) -> void:
	if who.is_in_group("player"):
		who.restart()
		# get_tree().call_deferred("reload_current_scene")
