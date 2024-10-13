extends CharacterBody3D

@export_category("Stats")
@export var health: int = 100
@export var damage: int = 10
@export var range: float = 200
@export var downTime: float = 0.1

var hitMarker: PackedScene = preload("res://scenes/hitLocMarker.tscn")

var player: CharacterBody3D  # Player reference

# Input function to handle shooting
func _input(event):
	if event.is_action_pressed("shoot"):
		print("Shoot action triggered")
		shoot()

# Function to perform shooting logic
func shoot():
	print("Shooting logic started")
	var center: Vector3 = global_transform.origin
	var player_position: Vector3 = find_player_position()
	if player_position != Vector3.ZERO:  # If player is within range
		print("Player in range at position: ", player_position)
		var spread_x: float = randf_range(-2.3, 2.3)  # Add random spread
		print("Random spread applied: ", spread_x)
		var rayEnd: Vector3 = player_position + Vector3(spread_x, 0, 0)
		print("Ray end position: ", rayEnd)
		var hit_result = getCharacterCollision(center, rayEnd)
		if hit_result:
			print("Hit detected at: ", hit_result.position)
			handleHit(hit_result)
		else:
			print("No hit detected")
	else:
		print("Player out of range")

# Function to handle raycasting and returning hit data
func getCharacterCollision(rayOrigin: Vector3, rayEnd: Vector3) -> Dictionary:
	print("Raycasting from ", rayOrigin, " to ", rayEnd)
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.new()
	query.from = rayOrigin
	query.to = rayEnd
	return space_state.intersect_ray(query)  # Pass the query object correctly

# Function to handle hit detection
func handleHit(intersection: Dictionary):
	var hitObject = intersection.collider
	print("Hit object: ", hitObject.name if hitObject else "None")
	spawnHitMarker(intersection.position)  # Spawn marker at the hit position
	if hitObject and hitObject.has_method("takeDmg"):
		print("Calling takeDmg on hit object")
		hitObject.takeDmg(hitObject, damage)  # Pass damage value to the hit object
		print("Hit: ", hitObject.name)
	else:
		print("Hit object has no takeDmg method")

# Function to spawn hit marker at the hit location
func spawnHitMarker(position: Vector3):
	print("Spawning hit marker at: ", position)
	var hitMarkerInst = hitMarker.instantiate()  # Create an instance of the marker scene
	hitMarkerInst.global_transform.origin = position  # Set the position of the marker
	add_child(hitMarkerInst)  # Add the marker to the current scene

# Function to detect the player and return their position
func find_player_position() -> Vector3:
	if player and global_transform.origin.distance_to(player.global_transform.origin) <= range:
		print("Player detected: ", player.name)
		return player.global_transform.origin
	print("Player out of range or not found")
	return Vector3.ZERO

# Function to handle character death
func die():
	print("Character died")
	queue_free()  # Remove the character from the scene

# Function to take damage
func takeDmg(collider, amount: int):
	print('Collider: ', collider.name if collider else "None")
	print("Taking damage: ", amount)
	health -= amount
	print("Health remaining: ", health)
	if health <= 0:
		print("Health depleted, character will die")
		die()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Node ready")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Optional logic to find the player and react
	pass
