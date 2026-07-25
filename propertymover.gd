extends Button
var moving
@onready var origparent = get_parent()
var root
@export var texture : String
enum PropertyKey {size, speed, jump, gravity, block_size, world_size, health, windspeed}
@export var property: PropertyKey

@onready var parent_cam = $"../../.."
@onready var initial_cam_pos = parent_cam.global_position

func _ready() -> void:
	$AnimatedSprite2D.animation = texture
	$AnimatedSprite2D.play()
	connect("pressed", clicked)
	root = get_tree().get_first_node_in_group("root")

func _process(delta: float) -> void:
	if moving:
		global_position = get_global_mouse_position() - Vector2(16, 16)

func clicked() -> void:
	# do nothing if game is already playing. this prevents the pickup from being moved after edit mode.
	if not get_tree().paused:
		return

	# only reparent on placement click, so the pickup sprite stays on top
	if moving:
		if get_parent() == origparent:
			var camera = get_node('../../..')
			reparent(root)
			position += camera.global_position - initial_cam_pos
	moving = !moving
