extends Node

#global hacks
#enum and dicts

enum sys {decompile, network_breach}
enum data {scramble_vars, ddos, corrupt}
enum control {reboot, self_destruct, antagonize, move_to_loc}
#hacks can have multiple effects, like rebooting, crashing, bricking, malfunctioning

var hacks = [data.ddos]


const names = {
	data.scramble_vars: "scramble_vars",
	data.ddos: "ddos",
	data.corrupt: "corrupt"
}


func getName(hackType):
	return names[hackType]

const decompile = {
	cost = 70
}
const ddos = {
	name = "ddos",
	cost = 50
}

const syst :Array[Dictionary] = [decompile, ddos]

func _ready() -> void:
	for system in syst:
		print(system.cost)



func _process(delta: float) -> void:
	pass
