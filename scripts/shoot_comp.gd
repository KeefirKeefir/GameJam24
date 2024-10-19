extends Node3D
#const hitMarker = preload("hitLocMarker.tscn")
var hitMarker: PackedScene = preload("res://scenes/hitLocMarker.tscn")

var camera
var cameraDir

func _ready():
	var parentNode = get_parent()
	camera = parentNode.get_node("TwistPivot/PitchPivot/Camera3D")

func spawnHitMarker(position: Vector3, parent):
	var hitMarkerInst = hitMarker.instantiate()  # Create an instance of the marker scene
	
	var world = get_tree().get_root()
	world.add_child(hitMarkerInst)  # Add the marker to the scene tree
	hitMarkerInst.global_transform.origin = position  # Set the position of the marker
	
func castHitscan(rangeInt, dmgInt:int, spreadAngle: Vector2):
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
	
	var rayOrigin = camera.project_ray_origin(center)
	var rayEnd = rayOrigin + rayDir * rangeInt
	
	var newRay = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var intersection = get_world_3d().direct_space_state.intersect_ray(newRay)
	
	if not intersection.is_empty():
		var hitObject = intersection.collider
		spawnHitMarker(intersection.position, hitObject)
		if hitObject.has_method("takeDmg"):
			print("hit: ",hitObject)
			hitObject.takeDmg(hitObject, dmgInt)
		
		print(hitObject.name)
	else:
		print("nothing")
	
func _process(delta: float) -> void:
	pass
