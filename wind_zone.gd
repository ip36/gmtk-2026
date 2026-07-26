extends Area2D

## normalized automatically
@export var direction: Vector2
@export var speed: float

var speed_multiplier: float = 1.0

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	sprite_2d.region_rect.position.x -= speed * speed_multiplier * delta

func _physics_process(delta: float) -> void:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			body.wind_movement = direction.normalized() * speed * speed_multiplier

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		body.is_in_wind = true
		# body.wind_movement = direction.normalized() * speed * speed_multiplier

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		body.is_in_wind = false
		# body.wind_movement = Vector2.ZERO
