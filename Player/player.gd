extends CharacterBody3D
#game Settings

#sounds
@onready var swapSound := $swapSound
@onready var dink := $Dink
#player nodes
#@onready var gunNode := get_node("TwistPivot/PitchPivot/Camera3D/socket/MeshInstance3D2")
@onready var Mov := $Movement
#@onready var Camera := $TwistPivot/PitchPivot/Camera3D
#other nodes
@onready var hud := get_tree().get_nodes_in_group("HUD")[0]  
@onready var hpBar := hud.get_node("health/hpBar")
@onready var hpNum := hud.get_node("health/hpNum")

#player stats
  # Default gravity value
@export var health : int = 100

#other player values

var parrying := false
var parryTime0 := 0.0
@export var parryTime := 0.5


#ready
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Mov.player = self

	#var enemies = get_tree().get_nodes_in_group("enemies")
	#for enemy in enemies: 
		#enemy.died.connect(switchGun)

#timerss
func parryTimer(delta:float) -> void:
	parryTime0 -= delta
	if parryTime0 <= 0.0 and parrying == true:
		parrying = false
		$"%shield".position.y = -1
	else:
		pass




func die() -> void:
	get_tree().quit()
	print("player dead")

func get_input() -> void:
	return Input.get_vector("left", "right", "forward", "back")

func takeDmg(collider: Node, amount: int, shape: int) -> void:
	if parrying == false:
		health -= amount
		
		print('collider: ', collider)
		print("Health remaining: ", health)
		hpBar.value = float(health)
		hpNum.text = str(health)
		
		if health <= 0:
			health = 0
			die()
	else:
		dink.pitch_scale = randf_range(0.9, 1.1)
		dink.play()

#main functions

func _physics_process(delta:float) -> void: #for consistent timings
	parryTimer(delta)
	

func _process(delta: float) -> void: #for more precise timings
	pass

		
func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("parry") and parryTime0 <= 0.0:
		parrying = true
		parryTime0 = parryTime
		$"%shield".position.y = -0.6
