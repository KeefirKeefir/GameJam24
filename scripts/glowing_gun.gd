extends Node3D

#example weapon

@onready var pistolShot = $PistolSound

var dmg = 20
var range = 100
var ammoMax :int = 8
var ammo : int = 8
var spread := 1.0

@export var reloadTime := 2.0
var reloadTime0 := 0.0
@export var delay := 0.2
var delay0 := 0.0

enum stateE {ready, firing, reloading}
var state = stateE.ready

@onready var player = get_tree().get_nodes_in_group("Player")[0]  
@onready var shootComp = player.get_node("ShootComp")

func _ready() -> void:
	pass
	#var player = get_tree().get_nodes_in_group("Player")[0]  
	#var shootComp = player.get_node("ShootComp")
	
func delayTimer(delta):
	delay0 -= delta
	if delay0 <= 0:
		self.rotation.x = deg_to_rad(0)
		if state != stateE.reloading:
			state = stateE.ready
		
	if state == stateE.reloading:
		reloadTime0 -= delta
		if reloadTime0 <= 0:
			self.rotation.z = deg_to_rad(0)
			state = stateE.ready
			ammo = ammoMax



func reload():
	if ammo < ammoMax:
		state = stateE.reloading
		reloadTime0 = reloadTime
		self.rotation.z = deg_to_rad(60)
	

func shoot():
	if state == stateE.ready and ammo > 0:
		var spreadRad = (Vector2(
			deg_to_rad(randf_range(-spread, spread)), 
			deg_to_rad(randf_range(-spread, spread))
			))
		shootComp.castHitscan(range, dmg , spreadRad)
		ammo -= 1
		delay0 = delay
		state = stateE.firing
		self.rotation.x = deg_to_rad(30)
		pistolShot.pitch_scale = randf_range(0.9, 1.1)
		pistolShot.play()
	elif ammo <= 0 and state != stateE.reloading:
		reload()

func _physics_process(delta: float):
	delayTimer(delta)
