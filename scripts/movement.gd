extends Node3D

@export var speed := 20
@export var jump_speed := 15
var velocity : Vector3 = Vector3()
var player : CharacterBody3D 
var camera: Camera3D

func _ready():
	player = get_parent() as CharacterBody3D
	camera = get_node("../TwistPivot/PitchPivot/CameraController/Camera3D")

func apply_movement(input_vector: Vector2):
	if input_vector.length() > 0:
		# Get the forward and right direction from the camera
		var movement_dir = camera.global_transform.basis * Vector3(input_vector.x, 0, input_vector.y).normalized()
		velocity.x = movement_dir.x * speed
		velocity.z = movement_dir.z * speed
	else:
		velocity.x = 0  # Stop movement if no input
		velocity.z = 0


func apply_gravity(gravity: float, delta: float):
	if not player.is_on_floor():
		velocity.y -= gravity * delta

func jump():
	if player.is_on_floor():
		velocity.y = jump_speed

func update_movement():
	player.velocity = velocity  # Set player velocity
	player.move_and_slide()  # No arguments needed
