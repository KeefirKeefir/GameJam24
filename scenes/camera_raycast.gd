extends Camera3D

var rayRange := 2000

func _input(event):
	if event.is_action_pressed("shoot"):
		getCameraCollision()
	
	
func getCameraCollision():
	var center = get_viewport().get_size()/2
	
	var rayOrigin = project_ray_origin(center)
	var rayEnd = rayOrigin + project_ray_normal(center) * rayRange
	
	var newIntersection = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var intersection = get_world_3d().direct_space_state.intersect_ray(newIntersection)

	if not intersection.is_empty():
		print(intersection.collider.name)
	else:
		print("nothing")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
