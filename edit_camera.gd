extends Camera2D

const PROPERTYMOVER = preload('uid://dt0dgop73ssd1')

@export var cam_speed: float = 500
@export var level_pickups: Array[PickupResource]

@onready var edit_mode_ui: CanvasLayer = $EditModeUI
@onready var v_box_container: VBoxContainer = $EditModeUI/VBoxContainer

var movement := Vector2.ZERO

func _ready():
	for p in level_pickups:
		var button = PROPERTYMOVER.instantiate()
		button.texture = p.texture
		button.get_node('Label').text = p.name
		button.property = p.property
		v_box_container.add_child(button)

func _process(delta: float) -> void:
	if !enabled:
		edit_mode_ui.visible = false
		return
	var dir = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	movement = movement.lerp(dir * delta * cam_speed, min(delta * 16, 1))
	translate(movement)
