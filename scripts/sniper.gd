extends CharacterBody3D

signal died

@onready var sniperShot := $SniperSound

@export_category("Stats")
@export var health: int = 30
@export var damage: int = 5
@export var range: float = 30

@export var downTime: float = 3 + randf_range(lrange.x, lrange.y)
@export var spread : float = 15

var isDead := false

var playerSpotted := false

var hitMarker: PackedScene = preload("res://scenes/hitLocMarker.tscn")

var camCorpse: PackedScene = preload("res://scenes/camCorpse.tscn")
#@export var player: CharacterBody3D  # Player reference
#var target: Camera3D
#var Player1 = get_path_to($StaticBody3D)
#@onready var player = get_node("Player1")
#@onready var target = Player1.get_node("TwistPivot/PitchPivot/CameraController/Camera3D")

@onready var player := get_tree().get_nodes_in_group("Player")[0]  
@onready var target := player.get_node("TwistPivot/PitchPivot/Camera3D")


var elapsedTime: float = 0.0  # Variable to store the accumulated delta (time passed)

@export var lrange:Vector2 = Vector2(-2,3)

func timer(delta:float) -> void:
	elapsedTime += delta
	
	# Check if the object's lifetime has been exceeded
	if downTime - elapsedTime <= 2 and global_transform.origin.distance_to(target.global_transform.origin) <= range:
		$CamGun/signal.visible = true
		
	if downTime - elapsedTime <= 0.3 and global_transform.origin.distance_to(target.global_transform.origin) <= range:
		$CamGun/signal.visible = false
		$CamGun/signal2.visible = true
	
	if elapsedTime >= downTime and global_transform.origin.distance_to(target.global_transform.origin) <= range:
			elapsedTime = 0
			downTime = 3 + randf_range(lrange.x, lrange.y)
			print(downTime)
			getCollision(range, damage)
			sniperShot.pitch_scale = randf_range(0.9, 1.1)
			sniperShot.play()
			$CamGun/signal.visible = false
			$CamGun/signal2.visible = false
	else:
		pass
		#print("Time left:", lifetime - elapsedTime)

	# calculate the direction of the player using 'player_new_position'
	# and multiply the result with the enemy speed and plug it all in move_and_slide()


#func _input(event):
	#if event.is_action_pressed("shoot"):
		#getCameraCollision()
	
func spawnCorpse() -> void:
	var corpseInst := camCorpse.instantiate()  # Create an instance of the marker scene
	var world := get_tree().get_root()
	world.add_child(corpseInst)
	corpseInst.global_transform.origin = self.position  # Set the position of the marker
	corpseInst.rotation = self.rotation
	
func spawnHitMarker(spawnPos: Vector3) -> void:
	var hitMarkerInst := hitMarker.instantiate()  # Create an instance of the marker scene
	
	var world := get_tree().get_root()
	world.add_child(hitMarkerInst)
	hitMarkerInst.global_transform.origin = spawnPos  # Set the position of the marker


# Function to perform shooting logic
func getCollision(range:int, dmg:int) -> void:
	
	
	var rayOrigin := self.position * 2
	var rayEnd :Vector3= target.global_position
	rayEnd.x += deg_to_rad(randf_range(-spread, spread))
	rayEnd.y += deg_to_rad(randf_range(-spread, spread))
	rayEnd.z += deg_to_rad(randf_range(-spread, spread))
	
	var newIntersection := PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var intersection := get_world_3d().direct_space_state.intersect_ray(newIntersection)
	
	if not intersection.is_empty():
		var hitObject:Object = intersection.collider
		spawnHitMarker(intersection.position)
		if hitObject.has_method("takeDmg"):
			print("hit: ",hitObject)
			hitObject.takeDmg(hitObject, dmg)
		
		print(hitObject.name)
	else:
		print("nothing")

	

# Function to handle raycasting and returning hit data



# Function to detect the player and return their position
func find_player_position() -> Vector3:

	look_at(target.global_position, Vector3.UP)
	
	#print(global_transform.origin.distance_to(target.global_transform.origin))
	if target and target.global_transform.origin.distance_to(target.global_transform.origin) <= range and playerSpotted == false:
		pass
		#downTime = 3 + randf_range(lrange.x, lrange.y)
		#print("Player detected: ", player.name)
		#return target.global_transform.origin
	#print("Player out of range or not found")
	return Vector3.ZERO

# Function to handle character death
func die() -> void:
	emit_signal("died")
	isDead = true
	print("Character died")
	#player.switchGun()
	spawnCorpse()
	queue_free()  # Remove the character from the scene

# Function to take damage
func takeDmg(collider:Node, amount: int) -> void:
	if isDead == false:
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
	
