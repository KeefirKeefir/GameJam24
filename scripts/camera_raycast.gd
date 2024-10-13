extends Camera3D

var rangeInt := 2000
#const hitMarker = preload("hitLocMarker.tscn")
var hitMarker: PackedScene = preload("res://scenes/hitLocMarker.tscn")

#func _input(event):
	#if event.is_action_pressed("shoot"):
		#getCameraCollision()
	
func spawnHitMarker(position: Vector3, parent):
	var hitMarkerInst = hitMarker.instantiate()  # Create an instance of the marker scene
	hitMarkerInst.global_transform.origin = position  # Set the position of the marker
	var world = get_tree().get_root()
	world.add_child(hitMarkerInst)  # Add the marker to the scene tree
	
func getCameraCollision(rangeInt, dmgInt:int, spreadRad: Vector3):
	var center = get_viewport().get_size()/2
	
	var rayOrigin = project_ray_origin(center)
	var rayEnd = rayOrigin + project_ray_normal(center) * rangeInt
	rayEnd.x += spreadRad.x
	rayEnd.y += spreadRad.y
	rayEnd.z += spreadRad.x
	#rayEnd = rangeInt * rayEnd
	
	var newIntersection = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var intersection = get_world_3d().direct_space_state.intersect_ray(newIntersection)
	
	if not intersection.is_empty():
		var hitObject = intersection.collider
		spawnHitMarker(intersection.position, hitObject)
		if hitObject.has_method("takeDmg"):
			print("hit: ",hitObject)
			hitObject.takeDmg(hitObject, dmgInt)
		
		print(hitObject.name)
	else:
		print("nothing")
	
	
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
