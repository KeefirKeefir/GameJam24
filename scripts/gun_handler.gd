extends Node3D

@onready var pistol = get_parent().get_node("TwistPivot/PitchPivot/Camera3D/socket/glowingGun")
@onready var socket = get_parent().get_node("TwistPivot/PitchPivot/Camera3D/socket")
var gunSlotA = null
var equippedSlot

var paths = {
	glowingGun = "res://scenes/glowingGun.tscn"
}

func _ready() -> void:
	loadGun(paths.glowingGun, gunSlotA)

func loadGun(toLoad, gunSlot):
	var loadedGun = load(toLoad)
	gunSlot = loadedGun.instantiate()
	gunSlotA = gunSlot
	equippedSlot = gunSlot
	#gunInst.global_transform.origin = Vector3.ZERO
	socket.add_child(gunSlotA)

func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("shoot"):
		
		#get_tree().get_nodes_in_group("guns")[0]
		equippedSlot.shoot()
 
