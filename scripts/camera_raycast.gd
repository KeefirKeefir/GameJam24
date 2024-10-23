extends Camera3D

#unused script

var rangeInt := 200
#const hitMarker = preload("hitLocMarker.tscn")
var hitMarker: PackedScene = preload("res://scenes/hitLocMarker.tscn")


var camera
var cameraDir

func spawnHitMarker(position: Vector3, parent) -> void:
	var hitMarkerInst = hitMarker.instantiate()  # Create an instance of the marker scene
	hitMarkerInst.global_transform.origin = position  # Set the position of the marker
	var world = get_tree().get_root()
	world.add_child(hitMarkerInst)  # Add the marker to the scene tree
	
func castHitscan(rangeInt, dmgInt:int, spreadAngle: Vector2) -> void:
	cameraDir = -camera.global_transform.basis.z.normalized()
	#angle math
	var axisH = camera.global_transform.basis.y.normalized()
	var axisV = cameraDir.cross(axisH).normalized()
	var rotQuatH = Quaternion(axisH, spreadAngle.x)
	var rotQuatV = Quaternion(axisV, spreadAngle.y)
	var rotQuat = rotQuatH * rotQuatV
	var rotBasis = Basis(rotQuat)
	
	var rayDir = Vector3(
		rotBasis.x.dot(cameraDir),
		rotBasis.y.dot(cameraDir),
		rotBasis.z.dot(cameraDir)
	)
	var center = get_viewport().get_size() / 2
	
	var rayOrigin = project_ray_origin(center)
	var rayEnd = rayOrigin + rayDir * rangeInt
	
	var newRay = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var intersection := get_world_3d().direct_space_state.intersect_ray(newRay)
	
	if not intersection.is_empty():
		var hitObject :Node= intersection.collider
		spawnHitMarker(intersection.position, hitObject)
		if hitObject.has_method("takeDmg"):
			print("hit: ",hitObject)
			hitObject.takeDmg(hitObject, dmgInt)
		
		print(hitObject.name)
	else:
		print("nothing")
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_node("../Camera3D")
	
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
