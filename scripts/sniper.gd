extends CharacterBody3D

@export_category("Stats")
@export var health: int = 30
@export var damage: int = 20
@export var range: float = 100
@export var downTime: float = 3
@export var spread = 15

var hitMarker: PackedScene = preload("res://scenes/hitLocMarker.tscn")


@export var player: CharacterBody3D  # Player reference
#var target: Camera3D

@onready var target = player.get_node("TwistPivot/PitchPivot/CameraController/Camera3D")
#@onready var player = get_tree().get_nodes_in_group("Player")[0]  


var elapsedTime: float = 0.0  # Variable to store the accumulated delta (time passed)

@export var lrange:Vector2 = Vector2(-2,3)

func timer(delta):
	elapsedTime += delta
	
	# Check if the object's lifetime has been exceeded
	if downTime - elapsedTime <= 2:
		$CamGun/signal.visible = true
		pass
	
	if elapsedTime >= downTime:
			elapsedTime = 0
			downTime = 5 + randf_range(lrange.x, lrange.y)
			print(downTime)
			getCollision(range, damage)
			$CamGun/signal.visible = false
	else:
		pass
		#print("Time left:", lifetime - elapsedTime)

	# calculate the direction of the player using 'player_new_position'
	# and multiply the result with the enemy speed and plug it all in move_and_slide()

func spawnHitMarker(position: Vector3, parent):
	var hitMarkerInst = hitMarker.instantiate()  # Create an instance of the marker scene
	hitMarkerInst.global_transform.origin = position  # Set the position of the marker
	var world = get_tree().get_root()
	world.add_child(hitMarkerInst)


# Function to perform shooting logic
func getCollision(rangeInt, dmgInt:int):
	var rayOrigin = self.position * 2
	var rayEnd = target.global_position
	rayEnd.x += deg_to_rad(randf_range(-spread, spread))
	rayEnd.y += deg_to_rad(randf_range(-spread, spread))
	
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
	

# Function to handle raycasting and returning hit data



# Function to detect the player and return their position
func find_player_position() -> Vector3:

	look_at(target.global_position, Vector3.UP)
	
	#print(global_transform.origin.distance_to(target.global_transform.origin))
	#if target and global_transform.origin.distance_to(target.global_transform.origin) <= range:
		#print("Player detected: ", player.name)
		#return target.global_transform.origin
	#print("Player out of range or not found")
	return Vector3.ZERO

# Function to handle character death
func die():
	print("Character died")
	player.switchGun()
	queue_free()  # Remove the character from the scene

# Function to take damage
func takeDmg(collider, amount: int):
	print('Collider: ', collider.name if collider else "None")
	print("Taking damage: ", amount)
	health -= amount
	print("Health remaining: ", health)
	if health <= 0:
		health = 0
		print("Health depleted, character will die")
		die()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var player = get_node("../TwistPivot/PitchPivot/CameraController/Camera3D")
	print(player)
	
	print(target)
	print("Node ready")
	
	print(player.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(target.global_position)
	find_player_position()
	
	timer(delta)
	
	# Optional logic to find the player and react
	
