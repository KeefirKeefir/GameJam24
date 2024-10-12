extends CharacterBody3D

var gravity := 40  # Default gravity value

func _ready():
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	movement_node.player = self

@onready var movement_node := $Movement
@onready var camera := $TwistPivot/PitchPivot/CameraController/Camera3D

func _physics_process(delta:float):
	var input_vector = Input.get_vector("left", "right", "forward", "back")
	
	# Apply movement and gravity through Movement node
	movement_node.apply_gravity(gravity, delta)
	movement_node.apply_movement(input_vector)

	# Update movement logic inside Movement node
	movement_node.update_movement()

	# Handle jump logic
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		movement_node.jump()


func get_input():
	return Input.get_vector("left", "right", "forward", "back")