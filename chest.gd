extends AnimatedSprite2D
var fading

func _ready() -> void:
	connect("animation_finished", fade)
	$Area2D.connect("body_entered", collected)

func fade() -> void:
	fading = true

func collected(who) -> void:
	if who.is_in_group("player"):
		$AudioStreamPlayer.play()
		play()
		get_tree().paused = true

func _process(delta: float) -> void:
	if fading:
		$ColorRect.color.a += delta
		if $ColorRect.color.a > 0.9:
			get_tree().quit()
