extends Area2D

## normalized automatically
@export var direction: Vector2
@export var speed: float

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	sprite_2d.region_rect.position.x -= speed * delta

# func _physics_process(delta: float) -> void:
# 	var bodies = get_overlapping_bodies()
# 	for body in bodies:
# 		print(body)
# 		if body.is_in_group("player"):
# 			body.wind_movement = direction.normalized() * speed
# 			 body.velocity += (direction.normalized() * speed * delta)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		body.wind_movement = direction.normalized() * speed

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		body.wind_movement = Vector2.ZERO
