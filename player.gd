extends CharacterBody2D
@export var properties = {"size" = 1.0,
	"speed" = 18000.0,
	"jumpspeed" = 400.0,
	"fallspeed" = 1000.0,
	"blocksize" = 1.0,
	"worldsize" = 1.0,
	"health" = 5.0}
var reductions = []
var current_countdown
var current_countdown_index
var reverse_gravity = false
var changing_blocks = []
var colors = [Color(255.014, 0.0, 255.014, 1.0), Color(0.851, 0.753, 0.0, 1.0), Color(0.0, 0.0, 1.0, 1.0), Color(0.0, 1.0, 1.0, 1.0), Color(0.475, 0.235, 0.0, 1.0), Color(0.0, 1.0, 0.0, 1.0), Color(1.0, 0.0, 0.0, 1.0)]
var currentanim
var starting_property_values
@onready var health_bar: ProgressBar = $HealthBar
@onready var tick_down_sound: AudioStreamPlayer = $TickDownSound

func _ready() -> void:
	starting_property_values = {}
	for i in properties:
		reductions.append(properties[i]/10)
		starting_property_values[i] = properties[i]
	for i in get_tree().get_nodes_in_group("changing_blocks"):
		changing_blocks.append(i)
	
	health_bar.visible = false
	health_bar.max_value = properties["health"]

func _process(delta: float) -> void:
	currentanim = null
	if current_countdown:
		tick_down_sound.pitch_scale = 0.2 + absf((properties[current_countdown] / starting_property_values[current_countdown] / 1.5))
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
		elif current_countdown == "health":
			health_bar.visible = true
			properties["health"] -= delta
			health_bar.value = properties["health"]
			if properties["health"] <= 0.0:
				get_tree().call_deferred("reload_current_scene")
	var dir = Input.get_axis("left", "right")
	if velocity.x != 0 and is_on_floor():
		currentanim = "run"
	if dir != 0:
		$AnimatedSprite2D.flip_h = (dir == -1)
	velocity.x = dir * properties["speed"] * delta
	if reverse_gravity or not is_on_floor():
		velocity.y += properties["fallspeed"] * delta
		if velocity.y > 0 or reverse_gravity:
			currentanim = "fall"
		else:
			currentanim = "jump"
	elif Input.is_action_pressed("up"):
		velocity.y = -properties["jumpspeed"] * scale.x
	move_and_slide()
	if currentanim == null:
		currentanim = "idle"
	if $AnimatedSprite2D.animation != currentanim:
		$AnimatedSprite2D.play(currentanim)

func set_countdown(property) -> void:
	tick_down_sound.playing = true
	current_countdown = properties.keys()[property]
	current_countdown_index = property
	$AnimatedSprite2D2.modulate = colors[property]
	$AnimatedSprite2D2.visible = true
