extends MeshInstance3D

@export var lifeTime: float = 1.0  # Set the lifetime duration (in seconds)
@export var lifeTime0: float = 1.0  # Variable to store the accumulated delta (time passed)


func lifeTimer(delta):
	lifeTime0 -= delta
	if lifeTime0 <= 0:
		queue_free()
	else:
		pass

func _physics_process(delta: float):
	lifeTimer(delta)
