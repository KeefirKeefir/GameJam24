extends Node3D

@export var speed := 25.0
@export var jump_speed := 25.0
var velocity : Vector3 = Vector3()
@onready var player := get_parent()
@onready var camera :Camera3D= get_node("../XPivot/Camera3D")
var Gravity := 40
@export var shiftJumpEnabled := false

var inputVector:Vector2

var airTime0 := 0.0
var BonusGravity := 3.0

var shifting := false
var dashing := false
var dashTime0 := 0.0 #..Time0 is the timer's current time, ..Time is the desired length of time
@export var dashTime := 0.06 #should be const, is var for testing, same for other Time floats

		
func dashTimer(delta:float) -> void:
	dashTime0 -= delta
	if dashTime0 <= 0 and dashing == true:
			dashing = false
			endDash()
	else:
		pass

func _ready() -> void:
	pass

func movePlayer(delta:float) -> void:
	applyGravity(delta)
	
	
	var forward := camera.global_transform.basis.z
	forward.y = 0
	forward = forward.normalized()
	var right := camera.global_transform.basis.x
	right.y = 0
	right = right.normalized()
	var movDir := (right * inputVector.x + forward * inputVector.y).normalized()
	
	# set velocity
	if dashing == true:
		dashVel(movDir)
	elif player.is_on_floor():
		walkVel(movDir, delta, inputVector)
	else:
		brakeVel(movDir, delta)
	
	applyMovement()
	

func applyGravity(delta: float) -> void:
	if player.is_on_floor():
		airTime0 = 0.0
	else:
		airTime0 += delta
	velocity.y -= (Gravity + Gravity * airTime0 * BonusGravity) * delta
	
func brakeVel(movDir:Vector3, delta:float) -> void:
	velocity.x = lerp(velocity.x, movDir.x * speed, delta * 4)
	velocity.z = lerp(velocity.z, movDir.z * speed, delta * 4)
	
func walkVel(movDir:Vector3, delta:float, inputVector:Vector2) -> void:
	if inputVector.length() > 0:
		velocity.x = movDir.x * speed
		velocity.z = movDir.z * speed
	else:
		velocity.x = lerp(velocity.x, movDir.x * speed, delta * 9)
		velocity.z = lerp(velocity.z, movDir.z * speed, delta * 9)

func dashVel(movDir:Vector3) -> void:
	if (movDir.x != 0 or movDir.z != 0):
		velocity.x = movDir.x * 300
		velocity.z = movDir.z * 300
	else:
		velocity.x = -camera.global_transform.basis.z.normalized().x * 300
		velocity.z = -camera.global_transform.basis.z.normalized().z * 300
	
func endDash() -> void:
	velocity *= 0

func jump() -> void:
	if player.is_on_floor():
		velocity.y = jump_speed

func applyMovement() -> void:
	if dashing == false:
		player.velocity.x = lerp(velocity.x, clamp(velocity.x, -speed, speed), 0.5)
		player.velocity.y = clamp(velocity.y, -1000, 1000)
		player.velocity.z = lerp(velocity.z, clamp(velocity.z, -speed, speed), 0.5)
	else:
		player.velocity = velocity
	player.move_and_slide()


func _physics_process(delta: float) -> void:
	movePlayer(delta)
	dashTimer(delta)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shift"):
		shifting = true
	else:
		shifting = false
	#jump and dash
	if event.is_action_pressed("shiftJumpDash") and shiftJumpEnabled == true:
		if shifting == true:
			jump()
		else:
			dashing = true
			dashTime0 = dashTime
	elif event.is_action_pressed("jump") and shiftJumpEnabled == false:
		jump()
	if event.is_action_pressed("dash") and shiftJumpEnabled == false:
		dashing = true
		dashTime0 = dashTime

func _process(delta: float) -> void:
	
	inputVector = Input.get_vector("left", "right", "forward", "back")
