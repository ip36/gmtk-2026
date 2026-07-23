extends CharacterBody2D
@export var properties = {"size" = 10,
	"speed" = 30000,
	"jumpspeed" = 600,
	"fallspeed" = 1000}
var reductions = []
var current_countdown
var current_countdown_index
var reverse_gravity = false

func _ready() -> void:
	for i in properties:
		reductions.append(properties[i]/10)

func _process(delta: float) -> void:
	if current_countdown:
		properties[current_countdown] -= reductions[current_countdown_index] * delta
		if current_countdown == "fallspeed" and properties["fallspeed"] < 0:
			reverse_gravity = true
			up_direction *= -1
		if current_countdown == "size":
			scale = Vector2(properties["size"], properties["size"])
	var dir = Input.get_axis("left", "right")
	velocity.x = dir * properties["speed"] * delta
	if reverse_gravity or not is_on_floor():
		velocity.y += properties["fallspeed"] * delta
	elif Input.is_action_pressed("up"):
		velocity.y = -properties["jumpspeed"]
	move_and_slide()

func set_countdown(property) -> void:
	current_countdown = properties.keys()[property]
	current_countdown_index = property
