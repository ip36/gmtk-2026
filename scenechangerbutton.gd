extends Button

@export var where: String
@export var override : bool
@export var override2 : bool

func _ready() -> void:
	if override2:
		var sum = 0
		for i in Variables.times.values():
			sum += i
		$"../Label2".text = "Your time: " + str(sum).pad_decimals(2)
	connect("pressed", func clicked():
		if override:
			Variables.currentlevel = 0
		else:
			Variables.currentlevel = get_parent().get_children().find(self)
		get_tree().change_scene_to_file("res://" + where + ".tscn"))
