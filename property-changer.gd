extends Area2D
var property
var player
var check1 = true
var check2 = true

func _ready() -> void:
	property = get_parent().property
	player = get_tree().get_first_node_in_group("player")
	connect("body_entered", collected)

func _process(delta: float) -> void:
	if get_tree().paused:
		return
	if check1:
		check1 = false
		return
	if check2:
		check2 = false
		for i in get_overlapping_areas():
			if i.is_in_group("cheese zone"):
				player.cheese_zone_placements += 1

func collected(whocollected) -> void:
	if not get_parent().visible:
		return
	
	if whocollected == player:
		player.set_countdown(property)
		get_parent().visible = false
		#get_parent().queue_free()
