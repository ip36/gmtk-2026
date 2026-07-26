extends GridContainer

func _ready() -> void:
	for i in get_children():
		i.get_child(0).text = str(snapped(Variables.times.values()[get_children().find(i)], 0.01))
		i.get_child(1).visible = Variables.cheeses[get_children().find(i)]
