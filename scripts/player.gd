extends CharacterBody3D

@onready var pistolShot = $PistolSound
@onready var shotgunShot = $ShotgunSound
@onready var swapSound = $swapSound
@onready var dink = $Dink

var dashing: bool = false
var dashTime :float = 0.0
var shifting: bool = false

var gravity := 40  # Default gravity value
@export var pistol = {
	canFire = true,
	dmg = 10,
	range = 100,
	isShotgun = false, 
	ammo = 12, 
	reload = 5.0,
	downtime = 0.5
}
@export var shotgun = {
	canFire = true,
	dmg = 6,
	range = 30,
	isShotgun = true, 
	ammo = 3, 
	reload = 6.0,
	downtime = 0
}

var parrying = false

enum guns {pistol, shotgun}

var gun = guns.pistol

@onready var gunModel = get_node("TwistPivot/PitchPivot/CameraController/Camera3D/MeshInstance3D/MeshInstance3D2")

var parryTime :float = 0.0

@export var health: int = 100

func parryTimer(delta):
	if parrying == true:
		parryTime += delta
		
		if parryTime >= 0.5:
				parrying = false
				$"%shield".position.y = -1
				parryTime = 0
				
	else:
		pass

func timer(delta):
	shotgun.downtime += delta
	
	if shotgun.downtime >= 1:
			shotgun.canFire = true
			gunModel.rotation.z = deg_to_rad(0)
	else:
		pass
		
func dashTimer(delta):
	dashTime += delta
	
	if dashTime >= 0.6:
			dashing = false
	else:
		pass

func switchGun():
	swapSound.pitch_scale = randf_range(0.9, 1.1)
	swapSound.play()
	if gun == guns.pistol:
		gun = guns.shotgun
		gunModel.rotation.y = deg_to_rad(-90)
	else:
		gunModel.rotation.y = deg_to_rad(90)
		gun = guns.pistol
		gunModel.rotation.z = deg_to_rad(0)

func _ready():
	
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	movement_node.player = self
	
	

@onready var movement_node := $Movement
@onready var camNode := $TwistPivot/PitchPivot/CameraController/Camera3D
@export var hud: CanvasLayer
@onready var hpBar = hud.get_node("infoBox/hpVisual")
@onready var hpText = hud.get_node("infoBox/hpVal")

func die():
	get_tree().quit()
	print("player dead")

func _physics_process(delta:float):
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Apply movement and gravity through Movement node
	movement_node.apply_gravity(gravity, delta)
	movement_node.apply_movement(input_vector)

	# Update movement logic inside Movement node
	movement_node.update_movement()
	if Input.is_action_pressed("jump"):
		shifting = true
	else:
		shifting = false
	
	# Handle jump logic
	if Input.is_action_just_pressed("dash"):
		if shifting == true:
			movement_node.jump()
		else:
			dashing = true
			dashTime = 0.0
			#movement_node.dash(input_vector)


	
	parryTimer(delta)
	print(parrying)
	timer(delta)
	dashTimer(delta)



func get_input():
	return Input.get_vector("left", "right", "forward", "back")

func _input(event):
	if event.is_action_pressed("shoot"):
		var igun = gun
		if igun == guns.pistol:
			camNode.getCameraCollision(pistol.range, pistol.dmg , Vector3.ZERO)
			pistolShot.pitch_scale = randf_range(0.9, 1.1)
			pistolShot.play()
			#sound and anim
		elif igun == guns.shotgun and shotgun.canFire == true:
			shotgun.canFire = false
			shotgun.downtime = 0
			gunModel.rotation.z = deg_to_rad(-30)
			for n in range(8):
				var spread = (Vector3(randf_range(-5, 5), randf_range(-5, 5), randf_range(-5, 5)))
				
				camNode.getCameraCollision(shotgun.range, shotgun.dmg, spread)
			shotgunShot.pitch_scale = randf_range(0.9, 1.1)
			shotgunShot.play()
	if event.is_action_pressed("parry") and parryTime == 0:
		parrying = true
		$"%shield".position.y = -0.6
		

func takeDmg(collider, amount: int):
	if parrying == false:
		health -= amount
		print(hpBar.value)
		
		print('collider: ', collider)
		print("Health remaining: ", health)
		hpBar.value = float(health)
		hpText.text = str(health)
		
		if health <= 0:
			health = 0
			die()
	else:
		dink.pitch_scale = randf_range(0.9, 1.1)
		dink.play()
		

# Maximum distance for the hitscan
var max_distance = 1000.0
