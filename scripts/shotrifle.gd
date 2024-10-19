extends Node3D


var canFire = true
var dmg = 5
var range = 30
var ammo = 4
var spread := 5.0
var pelletCount : int = 8

@export var reloadTime := 2.0
var reloadTime0 := 0.0
@export var delay := 0.5
var delay0 := 0.0

@onready var player = get_tree().get_nodes_in_group("Player")[0]  
@onready var shootComp = player.get_node("ShootComp")

func _ready() -> void:
	pass
	#var player = get_tree().get_nodes_in_group("Player")[0]  
	#var shootComp = player.get_node("ShootComp")
	
func delayTimer(delta):
	delay0 -= delta
	if delay0 <= 0:
		canFire = true
		self.rotation.x = deg_to_rad(0)
	else:
		pass

func shoot():
	if canFire:
		for i in range(pelletCount):
			var spreadRad = (Vector2(
				deg_to_rad(randf_range(-spread, spread)), 
				deg_to_rad(randf_range(-spread, spread))
				))
			shootComp.castHitscan(range, dmg , spreadRad)
		delay0 = delay
		canFire = false
		self.rotation.x = deg_to_rad(30)
	else:
		pass

func _physics_process(delta: float):
	delayTimer(delta)