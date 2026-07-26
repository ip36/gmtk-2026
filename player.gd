extends CharacterBody2D
@export var properties = {"size" = 1.0,
	"speed" = 18000.0,
	"jumpspeed" = 400.0,
	"fallspeed" = 1000.0,
	"blocksize" = 1.0,
	"worldsize" = 1.0,
	"health" = 6.5,
	"windspeed" = 1.0}
var reductions = []
var current_countdown
var current_countdown_index
var reverse_gravity = false
var changing_blocks = []
var colors = [Color(255.014, 0.0, 255.014, 1.0), Color(0.851, 0.753, 0.0, 1.0), Color(0.0, 0.0, 1.0, 1.0), Color(0.0, 1.0, 1.0, 1.0), Color(0.475, 0.235, 0.0, 1.0), Color(0.0, 1.0, 0.0, 1.0), Color(1.0, 0.0, 0.0, 1.0), Color(0.7, 0.7, 0.9, 1.0)]
var currentanim
var cheese_zone_placements = 0
var starting_property_values
var wind_movement: Vector2
var is_in_wind: bool = false
var start_pos: Vector2
@onready var health_bar: ProgressBar = $HealthBar
@onready var tick_down_sound: AudioStreamPlayer = $TickDownSound
@export var potions : int

func _ready() -> void:
	start_pos = global_position
	starting_property_values = {}
	for i in properties:
		reductions.append(properties[i]/10)
		starting_property_values[i] = properties[i]
	for i in get_tree().get_nodes_in_group("changing_blocks"):
		changing_blocks.append(i)

	health_bar.visible = false
	$TextureRect.visible = false
	health_bar.max_value = properties["health"]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart_level"):
		restart()

func restart():
	tick_down_sound.stop()

	current_countdown = null

	for i in properties:
		properties[i] = starting_property_values[i]

	scale = Vector2.ONE
	$Camera2D.zoom = Vector2.ONE * 2.025

	for i in changing_blocks:
		if i.scale > Vector2():
			i.scale = Vector2.ONE

	health_bar.visible = false
	$TextureRect.visible = false

	$AnimatedSprite2D2.visible = false

	is_in_wind = false
	wind_movement = Vector2.ZERO

	velocity = Vector2.ZERO

	# wtf is the cheese zone
	cheese_zone_placements = 0

	global_position = start_pos

	for p in get_tree().get_nodes_in_group("pickup"):
		p.visible = true

	await get_tree().process_frame
	await get_tree().process_frame

	get_tree().paused = true
	var ecam = get_tree().get_first_node_in_group("editcamera")
	ecam.enabled = true
	ecam.edit_mode_ui.visible = true
	get_tree().get_first_node_in_group("player").get_node("Camera2D").enabled = false

func _process(delta: float) -> void:
	Variables.times[get_tree().current_scene.scene_file_path] += delta
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
				restart()
		elif current_countdown == "worldsize":
			scale += Vector2(reductions[5], reductions[5]) * delta
			if $Camera2D.zoom.x > 1.1:
				$Camera2D.zoom = 2.025 * Vector2(properties["worldsize"], properties["worldsize"])
			if is_on_ceiling() and is_on_floor():
				restart()
		elif current_countdown == "blocksize":
			for i in changing_blocks:
				if i.scale > Vector2():
					i.scale -= (Vector2(reductions[4], reductions[4]) * delta)
		elif current_countdown == "health":
			health_bar.visible = true
			$TextureRect.visible = true
			properties["health"] -= delta
			health_bar.value = properties["health"]
			if properties["health"] <= 0.0:
				restart()
		elif current_countdown == "windspeed":
			var wind_zones = get_tree().get_nodes_in_group("wind")
			properties["windspeed"] -= delta / 3
			for zone in wind_zones:
				zone.speed_multiplier = properties["windspeed"]

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
	if is_in_wind:
		velocity += wind_movement
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
