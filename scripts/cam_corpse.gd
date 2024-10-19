extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.center_of_mass.x = randf_range(-10, 10)
	self.center_of_mass.y = randf_range(-10, 10)
	self.center_of_mass.z = randf_range(-10, 10)

var elapsedTime = 0

func timer(delta):
	elapsedTime += delta

	if elapsedTime >= 3:
		self.axis_lock_angular_x = true
		self.axis_lock_angular_y = true
		self.axis_lock_angular_z = true
		self.axis_lock_linear_x = true
		self.axis_lock_linear_y = true
		self.axis_lock_linear_z = true
	else:
		pass

func _process(delta: float) -> void:
	timer(delta)
