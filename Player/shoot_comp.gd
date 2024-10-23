extends Node3D
#const hitMarker = preload("hitLocMarker.tscn")
var hitMarker:PackedScene = preload("res://scenes/hitLocMarker.tscn")

@onready var camera := get_parent().get_node("XPivot/Camera3D")
var cameraDir:Vector3

func _ready() -> void:
	pass
	#var parentNode = get_parent()
	#camera = parentNode.get_node("TwistPivot/PitchPivot/Camera3D")

func spawnHitMarker(spawnPos:Vector3) -> void:
	var hitMarkerInst := hitMarker.instantiate()  # Create an instance of the marker scene
	
	var world := get_tree().get_root()
	world.add_child(hitMarkerInst)  # Add the marker to the scene tree
	hitMarkerInst.global_transform.origin = spawnPos  # Set the position of the marker
	
func castHitscan(range:int, dmg:int, spreadAngle: Vector2) -> void:
	cameraDir = -camera.global_transform.basis.z.normalized()
	#angle math
	var axisH:Vector3 = camera.global_transform.basis.y.normalized()
	var axisV := cameraDir.cross(axisH).normalized()
	var rotQuatH := Quaternion(axisH, spreadAngle.x)
	var rotQuatV := Quaternion(axisV, spreadAngle.y)
	var rotQuat := rotQuatH * rotQuatV
	var rotBasis := Basis(rotQuat)
	
	var rayDir := Vector3(
		rotBasis.x.dot(cameraDir),
		rotBasis.y.dot(cameraDir),
		rotBasis.z.dot(cameraDir)
	)
	var center:Vector2= get_viewport().get_size() / 2
	
	var rayOrigin:Vector3= camera.project_ray_origin(center)
	var rayEnd := rayOrigin + rayDir * range
	
	var newRay := PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd, 2)
	newRay.collide_with_areas = true
	var intersection := get_world_3d().direct_space_state.intersect_ray(newRay)
	
	if not intersection.is_empty():
		var hitObject:Node = intersection.collider
		spawnHitMarker(intersection.position)
		if hitObject.has_method("takeDmg"):
			print("hit: ",hitObject)
			hitObject.takeDmg(hitObject, dmg, intersection.shape)
		print(hitObject.name)
	else:
		print("nothing")
	
func _process(delta: float) -> void:
	pass
