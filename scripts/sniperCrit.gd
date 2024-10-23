extends Area3D

@onready var parent = get_parent()

func takeDmg(collider:Node, amount: int, shape: int) -> void: 
	parent.takeDmg(collider, amount, shape)
