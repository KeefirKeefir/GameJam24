extends Node3D

@export var speed := 20
@export var jump_speed := 15
var velocity : Vector3 = Vector3()
var player : CharacterBody3D 
var camera : Camera3D

func _ready() -> void:
	player = get_parent() as CharacterBody3D
	camera = get_node("../TwistPivot/PitchPivot/Camera3D")

func apply_movement(input_vector: Vector2) -> void:
	var forward := camera.global_transform.basis.z
	forward.y = 0
	forward = forward.normalized()
	var right := camera.global_transform.basis.x
	right.y = 0
	right = right.normalized()
	var movement_dir := (right * input_vector.x + forward * input_vector.y).normalized()

	if player.dashing == true:
		if (movement_dir.x != 0 or movement_dir.z != 0):
			velocity.x = movement_dir.x * 300
			velocity.z = movement_dir.z * 300
		else:
			velocity.x = -camera.global_transform.basis.z.normalized().x * 300
			velocity.z = -camera.global_transform.basis.z.normalized().z * 300
	elif input_vector.length() > 0:
		# Get the forward and right direction from the camera
		velocity.x = movement_dir.x * speed
		velocity.z = movement_dir.z * speed
	else:
		velocity.x = 0  # Stop movement if no input
		velocity.z = 0


func apply_gravity(gravity: float, delta: float) -> void:
	velocity.y -= gravity * delta
	

func jump() -> void:
	if player.is_on_floor():
		velocity.y = jump_speed

	
func update_movement() -> void:
	player.velocity = velocity  # Set player velocity
	player.move_and_slide()  # No arguments needed
