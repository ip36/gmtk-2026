extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label: Label = $Label

func _process(delta: float) -> void:
	if !player.current_countdown:
		label.text = ""
		return

	label.text = countdown_display_name(player.current_countdown) + ": " + str(
		player.properties[player.current_countdown]
	).pad_decimals(2)

func countdown_display_name(countdown: String):
	if countdown == "size":
		return "Size"
	if countdown == "speed":
		return "Speed"
	if countdown == "jumpspeed":
		return "Jump Height"
	if countdown == "fallspeed":
		return "Gravity"
	if countdown == "blocksize":
		return "Block Size"
	if countdown == "worldsize":
		return "World Size"
	if countdown == "health":
		return "Health"
	return countdown.capitalize()
