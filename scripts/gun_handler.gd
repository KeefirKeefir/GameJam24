extends Node3D

#@onready var pistol = get_parent().get_node("TwistPivot/PitchPivot/Camera3D/socket/glowingGun")
@onready var socket := get_parent().get_node("TwistPivot/PitchPivot/Camera3D/socket")
#these hold a reference to the gun's node
var primSlot : Object = null
var secSlot : Object = null
var altSlot : Object = null
var equippedSlot : Object

var paths := {
	glowingGun = "res://scenes/glowingGun.tscn",
	shotrifle = "res://scenes/shotrifle.tscn"
}

func _ready() -> void:
	primSlot = loadGun(primSlot, paths.glowingGun)
	secSlot = loadGun(secSlot, paths.shotrifle)

func equipGun(gunSlot:Object) -> void:
	if equippedSlot != null:
		equippedSlot.visible = false
	equippedSlot = gunSlot
	print(equippedSlot)
	equippedSlot.visible = true
	

func loadGun(gunSlot: Node, toLoad: String) -> Object: #done at the beginning of the game, toLoad is chosen by player
	var loadedGun := load(toLoad)
	if gunSlot == null:
		gunSlot = loadedGun.instantiate()
		equipGun(gunSlot)
		#gunInst.global_transform.origin = Vector3.ZERO
		socket.add_child(gunSlot)
	else: #swap
		pass
	return gunSlot

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("equipPrimary"): # and primSlot != null:
		equipGun(primSlot)
	if event.is_action_pressed("equipSecondary"): #and secSlot != null:
		equipGun(secSlot)
	if event.is_action_pressed("equipAlternate") and altSlot != null:
		equipGun(altSlot)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		#get_tree().get_nodes_in_group("guns")[0]
		equippedSlot.shoot()
	if event.is_action_pressed("reload"):
		equippedSlot.reload()
 
