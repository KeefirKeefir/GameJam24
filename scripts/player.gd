extends CharacterBody3D



var gravity := 40  # Default gravity value
@export var pistol = {
	dmg = 10,
	range = 100,
	isShotgun = false, 
	ammo = 12, 
	reload = 5.0,
	downtime = 0.5
}
@export var shotgun = {
	dmg = 6,
	range = 150,
	isShotgun = true, 
	ammo = 3, 
	reload = 6.0,
	downtime = 1.5
}

enum guns {pistol, shotgun}

var gun = guns.pistol

@onready var gunModel = get_node("TwistPivot/PitchPivot/CameraController/Camera3D/MeshInstance3D/MeshInstance3D2")


@export var health: int = 100
#dmg i
#range i
#isshotgun i
#ammo i
#reloadtime flt
#firerate flt
#sound
#anim
#enumWeapons index
func switchGun():
	if gun == guns.pistol:
		gun = guns.shotgun
		gunModel.rotation.y = deg_to_rad(-90)
	else:
		gunModel.rotation.y = deg_to_rad(90)
		gun = guns.pistol



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
	print("player dead")

func _physics_process(delta:float):
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
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

func _input(event):
	if event.is_action_pressed("shoot"):
		var igun = gun
		if igun == guns.pistol:
			camNode.getCameraCollision(pistol.range, pistol.dmg , Vector2.ZERO)
			#sound and anim
		elif igun == guns.shotgun:
			for n in range(8):
				var spread = (Vector2(randf_range(-30, 30), randf_range(-30, 30)))
				
				camNode.getCameraCollision(shotgun.range, shotgun.dmg, spread)
		

func takeDmg(collider, amount: int):
	health -= amount
	print(hpBar.value)
	
	print('collider: ', collider)
	print("Health remaining: ", health)
	hpBar.value = float(health)
	hpText.text = str(health)
	
	if health <= 0:
		health = 0
		die()

# Maximum distance for the hitscan
var max_distance = 1000.0
