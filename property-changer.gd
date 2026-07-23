extends Area2D
enum PropertyKey {size, speed, jump, gravity}
@export var property: PropertyKey
var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	connect("body_entered", collected)

func collected(whocollected) -> void:
	if whocollected == player:
		player.set_countdown(property)
		queue_free()
