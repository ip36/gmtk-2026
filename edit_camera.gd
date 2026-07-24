extends Camera2D

@export var cam_speed: float = 10

var movement := Vector2.ZERO

func _process(delta: float) -> void:
	var dir = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	movement = movement.lerp(dir * delta * cam_speed, delta * 16)
	translate(movement)
