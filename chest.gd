extends AnimatedSprite2D
var fading

func _ready() -> void:
	connect("animation_finished", fade)
	$Area2D.connect("body_entered", collected)

func fade() -> void:
	fading = true

func collected(who) -> void:
	if who.is_in_group("player"):
		if who.cheese_zone_placements < who.potions:
			Variables.cheeses[Variables.currentlevel] = true
		$AudioStreamPlayer.play()
		Variables.currentlevel += 1
		play()
		get_tree().paused = true

func _process(delta: float) -> void:
	if fading:
		$ColorRect.color.a += delta
		if $ColorRect.color.a > 0.9:
			get_tree().change_scene_to_file("res://Levels/Level" + str(Variables.currentlevel + 1) + ".tscn")
