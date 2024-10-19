extends Node3D
@export_category("Rotation clamp")

@export var mouse_sensitivity := 0.0025
@export var yaw_clamp : Vector2 = Vector2(-180.0, 180.0)  # Min and max for yaw
@export var pitch_clamp : Vector2 = Vector2(-89.95, 90.0)   # Min and max for pitch
#min pitch is -89.95 because a value of -89.96 or higher inverts forward/backward controls

var twist_input := 0.0
var pitch_input := 0.0

@onready var camera := $PitchPivot # Reference to the pitch pivot (child node)


# Function to handle camera rotation
func rotate_camera(event: InputEventMouseMotion) -> void:
	# Update twist (rotation around the Y-axis) and pitch (rotation around the X-axis)
	twist_input += -event.relative.x * mouse_sensitivity
	pitch_input += -event.relative.y * mouse_sensitivity

	# Apply twist rotation (Y-axis) to the parent node
	rotate_y(twist_input)
	rotation_degrees.y = clamp(rotation_degrees.y, yaw_clamp.x, yaw_clamp.y)  # Clamp Y rotation

	# Apply pitch rotation (X-axis) to the pitch pivot
	camera.rotate_x(pitch_input)
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, pitch_clamp.x, pitch_clamp.y)  # Clamp X rotation

	# Clear inputs after applying them to avoid continuous rotation
	twist_input = 0.0
	pitch_input = 0.0

func _process(_delta: float) -> void:
	# Check for mouse mode toggle
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_camera(event)
