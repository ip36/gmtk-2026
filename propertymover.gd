extends Button
var moving
@onready var origparent = get_parent()
var root
@export var texture : String
enum PropertyKey {size, speed, jump, gravity, block_size, world_size, health}
@export var property: PropertyKey

func _ready() -> void:
	$AnimatedSprite2D.animation = texture
	$AnimatedSprite2D.play()
	connect("pressed", clicked)
	root = get_tree().get_first_node_in_group("root")

func _process(delta: float) -> void:
	if moving:
		global_position = get_global_mouse_position() - Vector2(16, 16)

func clicked() -> void:
	if get_parent() == origparent:
		reparent(root)
	moving = !moving
