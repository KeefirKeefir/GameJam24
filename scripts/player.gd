extends CharacterBody3D
#game Settings
@export var shiftJumpEnabled := false
#sounds
@onready var pistolShot = $PistolSound
@onready var shotgunShot = $ShotgunSound
@onready var swapSound = $swapSound
@onready var dink = $Dink
#player nodes
@onready var gunNode = get_node("TwistPivot/PitchPivot/Camera3D/MeshInstance3D/MeshInstance3D2")
@onready var movNode := $Movement
@onready var camNode := $TwistPivot/PitchPivot/Camera3D
#other nodes
@export var hud: CanvasLayer
@onready var hpBar = hud.get_node("infoBox/hpVisual")
@onready var hpText = hud.get_node("infoBox/hpVal")

#player stats
var gravity := 40  # Default gravity value
@export var health: int = 100

#other player values
var shifting := false
var dashing := false
var dashTime0 := 0.0 #..Time0 is the timer's current time, ..Time is the desired length of time
@export var dashTime := 0.06 #should be const, is var for testing, same for other Time floats
var parrying := false
var parryTime0 := 0.0
@export var parryTime := 0.5

#TODO: items should be moved to their own scenes and scripts
enum guns {pistol, shotgun}
var gun = guns.pistol
@export var pistol = {
	canFire = true,
	dmg = 10,
	range = 100,
	isShotgun = false, 
	ammo = 12, 
	reload = 5.0,
	delay0 = 0.0,
	delay = 0.5
}
@export var shotgun = {
	canFire = true,
	dmg = 6,
	range = 30,
	isShotgun = true, 
	ammo = 3, 
	reload = 6.0,
	delay0 = 0,
	delay = 1
}
#ready
func _ready():
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	movNode.player = self
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies: 
		enemy.died.connect(switchGun)

#timers
func parryTimer(delta):
	parryTime0 -= delta
	if parryTime0 <= 0.0 and parrying == true:
		parrying = false
		$"%shield".position.y = -1
	else:
		pass

func shotgunTimer(delta):
	shotgun.delay0 -= delta
	if shotgun.delay0 <= 0:
			shotgun.canFire = true
			#gunNode.rotation.z = deg_to_rad(0)
	else:
		pass

func dashTimer(delta):
	dashTime0 -= delta
	if dashTime0 <= 0:
			dashing = false
	else:
		pass

#functions
func switchGun():
	swapSound.pitch_scale = randf_range(0.9, 1.1)
	swapSound.play()
	if gun == guns.pistol:
		gun = guns.shotgun
		#gunNode.rotation.y = deg_to_rad(-90)
	elif gun == guns.shotgun:
		gun = guns.pistol
		#gunNode.rotation.y = deg_to_rad(90)
		#gunNode.rotation.z = deg_to_rad(0)

func die():
	get_tree().quit()
	print("player dead")

func get_input():
	return Input.get_vector("left", "right", "forward", "back")

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

#main functions

func _physics_process(delta:float): #for consistent timings
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# Apply movement and gravity through Movement node
	movNode.apply_gravity(gravity, delta)
	movNode.apply_movement(input_vector)
	# Update movement logic inside Movement node
	movNode.update_movement()
	# timers
	parryTimer(delta)
	shotgunTimer(delta)
	dashTimer(delta)

func _process(delta: float): #for more precise timings
	
	if Input.is_action_pressed("shift"):
		shifting = true
	else:
		shifting = false
	#jump and dash
	if Input.is_action_just_pressed("shiftJumpDash") and shiftJumpEnabled == true:
		if shifting == true:
			movNode.jump()
		else:
			dashing = true
			dashTime0 = dashTime
	elif Input.is_action_just_pressed("jump") and shiftJumpEnabled == false:
		movNode.jump()
	if Input.is_action_just_pressed("dash") and shiftJumpEnabled == false:
		dashing = true
		dashTime0 = dashTime
		
#func _unhandled_input(event: InputEvent):
	#if event.is_action_pressed("shoot"):
		#var igun = gun
		#if igun == guns.pistol:
			#camNode.castHitscan(pistol.range, pistol.dmg , Vector2.ZERO)
			#pistolShot.pitch_scale = randf_range(0.9, 1.1)
			#pistolShot.play()
			##sound and anim
		#elif igun == guns.shotgun and shotgun.canFire == true:
			#shotgun.canFire = false
			#shotgun.delay0 = shotgun.delay
			#gunNode.rotation.z = deg_to_rad(-30)
			#for n in range(8):
				#var spread = (Vector2(deg_to_rad(randf_range(-5, 5)), deg_to_rad(randf_range(-5, 5))))
				#camNode.castHitscan(shotgun.range, shotgun.dmg, spread)
			#shotgunShot.pitch_scale = randf_range(0.9, 1.1)
			#shotgunShot.play()
	#if event.is_action_pressed("parry") and parryTime0 <= 0.0:
		#parrying = true
		#parryTime0 = parryTime
		#$"%shield".position.y = -0.6
