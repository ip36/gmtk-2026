extends Button

@export var where: String

func _ready() -> void:
	connect("pressed", func clicked():
		Variables.currentlevel = get_parent().get_children().find(self)
		get_tree().change_scene_to_file("res://" + where + ".tscn"))
