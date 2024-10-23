extends Node3D
@export_category("Rotation clamp")

@export var MouseSensitivity := 0.0025
@export var TwistClamp : Vector2 = Vector2(-180.0, 180.0)  # Min and max for yaw
@export var PitchClamp : Vector2 = Vector2(-89.95, 90.0)   # Min and max for pitch
#min pitch is -89.95 because a value of -89.96 or higher inverts forward/backward controls

var twist_input := 0.0
var pitch_input := 0.0

@onready var Mov := get_parent().get_node("Movement")
@onready var Cam := $Camera3D
@onready var Player := get_parent()
#$PitchPivot # Reference to the pitch pivot (child node)

var BobFreq := 0.45
var BobAmp := 0.15
var bobTime0 := 0.0
var prevSineVal := 0.0
@onready var CamPrevVal = Cam.transform.origin
@onready var CamOGVal = Cam.transform.origin

# Function to handle camera rotation
func applyRotation(event: InputEventMouseMotion) -> void:

	twist_input += -event.relative.x * MouseSensitivity
	pitch_input += -event.relative.y * MouseSensitivity

	Player.rotate_y(twist_input)
	rotation_degrees.y = clamp(rotation_degrees.y, TwistClamp.x, TwistClamp.y) 

	rotate_x(pitch_input)
	rotation_degrees.x = clamp(rotation_degrees.x, PitchClamp.x, PitchClamp.y)  

	twist_input = 0.0
	pitch_input = 0.0

func _process(delta: float) -> void:
	# Check for mouse mode toggle
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	bobTime0 += delta * Player.velocity.length() * float(Player.is_on_floor())
	Cam.transform.origin = headbob(bobTime0)
	
	if CamPrevVal == Cam.transform.origin:
		Cam.transform.origin = CamOGVal
	else:
		CamPrevVal = Cam.transform.origin

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		applyRotation(event)

func headbob(time) ->Vector3:
	if Mov.dashing == true:
		return CamOGVal
	
	var pos = Vector3.ZERO
	var sineVal = sin(time * BobFreq)
	if abs(sineVal - 1.0) < 0.01:
		bobTime0 += PI
	pos.y = sineVal * BobAmp
	prevSineVal = sineVal
	return pos
