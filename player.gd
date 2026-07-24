extends CharacterBody2D
@export var properties = {"size" = 1.0,
	"speed" = 10000.0,
	"jumpspeed" = 500.0,
	"fallspeed" = 1000.0,
	"blocksize" = 1.0,
	"worldsize" = 1.0}
var reductions = []
var current_countdown
var current_countdown_index
var reverse_gravity = false
var changing_blocks = []

func _ready() -> void:
	for i in properties:
		reductions.append(properties[i]/10)
	for i in get_tree().get_nodes_in_group("changing_blocks"):
		changing_blocks.append(i)

func _process(delta: float) -> void:
	if current_countdown:
		properties[current_countdown] -= reductions[current_countdown_index] * delta
		if current_countdown == "fallspeed" and properties["fallspeed"] < 0:
			reverse_gravity = true
			up_direction *= -1
		elif current_countdown == "size":
			scale -= Vector2(reductions[0], reductions[0]) * delta
			if scale.x <= 0:
				get_tree().call_deferred("reload_current_scene")
		elif current_countdown == "worldsize":
			scale += Vector2(reductions[5], reductions[5]) * delta
			if $Camera2D.zoom.x > 1.1:
				$Camera2D.zoom = 2.025 * Vector2(properties["worldsize"], properties["worldsize"])
			if is_on_ceiling() and is_on_floor():
				get_tree().call_deferred("reload_current_scene")
		elif current_countdown == "blocksize":
			for i in changing_blocks:
				if i.scale > Vector2():
					i.scale -= (Vector2(reductions[4], reductions[4]) * delta)
	var dir = Input.get_axis("left", "right")
	velocity.x = dir * properties["speed"] * delta
	if reverse_gravity or not is_on_floor():
		velocity.y += properties["fallspeed"] * delta
	elif Input.is_action_pressed("up"):
		velocity.y = -properties["jumpspeed"] * scale.x
	move_and_slide()

func set_countdown(property) -> void:
	current_countdown = properties.keys()[property]
	current_countdown_index = property
