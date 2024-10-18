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
	var movement_dir = camera.global_transform.basis * Vector3(input_vector.x, 0, input_vector.y).normalized()
	if input_vector.length() > 0 and player.dashing != true:
		# Get the forward and right direction from the camera
		
		velocity.x = movement_dir.x * speed
		velocity.z = movement_dir.z * speed
	elif player.dashing == true and (movement_dir.x != 0 or movement_dir.z != 0):
		velocity.x = movement_dir.x * 300
		velocity.z = movement_dir.z * 300
	elif player.dashing == true:
		velocity.x = -camera.global_transform.basis.z.normalized().x * 300
		velocity.z = -camera.global_transform.basis.z.normalized().z * 300
	else:
		velocity.x = 0  # Stop movement if no input
		velocity.z = 0


func apply_gravity(gravity: float, delta: float):
	velocity.y -= gravity * delta
	

func jump():
	if player.is_on_floor():
		velocity.y = jump_speed

func dash(input_vector):
	var movement_dir = camera.global_transform.basis * Vector3(input_vector.x, 0, input_vector.y).normalized()
	player.position.x = player.position.x + movement_dir.x * 10
	player.position.z = player.position.z + movement_dir.z * 10
	
	
func update_movement():
	player.velocity = velocity  # Set player velocity
	player.move_and_slide()  # No arguments needed
