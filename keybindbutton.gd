extends Button
var lookingforkey = false
var resettimer = 0
var resettimermax = 1
var clickdetection
## Add the exact name of the inputmap action this button should rebind(Case sensetive.)
@export var InputToRebind : String = "Example Input"

func _ready():
	connect("button_down", igotpressed)

func _process(delta):
	if resettimer <= 0 and not lookingforkey:
		text = "Change keybind: 
			" + InputToRebind
	else:
		resettimer -= delta

func igotpressed():
	if not lookingforkey:
		text = "Press the key you want to assign.
			Click again to cancel"
		lookingforkey = true
	else:
		text = "Change keybind: 
			" + InputToRebind
		lookingforkey = false

func _input(event):
	if event is InputEventKey and event.pressed and lookingforkey:
		InputMap.action_erase_events(InputToRebind)
		InputMap.action_add_event(InputToRebind, event)
		text =  InputToRebind + " set to: 
			" + str(event.as_text())
		resettimer = resettimermax
		lookingforkey = false
