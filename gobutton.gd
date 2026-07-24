extends Button

func _ready() -> void:
	connect("pressed", clicked)
	get_tree().paused = true

func clicked() -> void:
	visible = false
	get_tree().paused = false
	get_tree().get_first_node_in_group("editcamera").enabled = false
	get_tree().get_first_node_in_group("player").get_node("Camera2D").enabled = true
