extends Button
var lookingforkey = false
var clickdetection
var origtext
## Add the exact name of the inputmap action this button should rebind(Case sensetive.)
@export var InputToRebind : String = "Example Input"

func _ready():
	origtext = text
	connect("button_down", igotpressed)

func igotpressed():
	if not lookingforkey:
		text = "Listening for input.
			Click to cancel"
		lookingforkey = true
	else:
		text = origtext
		lookingforkey = false

func _input(event):
	if event is InputEventKey and event.pressed and lookingforkey:
		InputMap.action_erase_events(InputToRebind)
		InputMap.action_add_event(InputToRebind, event)
		lookingforkey = false
