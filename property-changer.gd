extends Area2D
var property
var player

func _ready() -> void:
	property = get_parent().property
	player = get_tree().get_first_node_in_group("player")
	connect("body_entered", collected)

func collected(whocollected) -> void:
	if whocollected == player:
		player.set_countdown(property)
		get_parent().queue_free()
