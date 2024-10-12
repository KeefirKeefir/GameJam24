extends NavigationAgent3D

@export var boundaries:Vector3 = Vector3(10.0, 0, 10.0)

func random_nav_position()->Vector3:
	var rand_pos = Vector3(
		randf_range(-boundaries.x, boundaries.x),
		0,
		randf_range(-boundaries.z, boundaries.z)
	)
	return rand_pos
