extends MeshInstance3D

@export var lifetime: float = 5.0  # Set the lifetime duration (in seconds)
var elapsed_time: float = 0.0  # Variable to store the accumulated delta (time passed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Accumulate delta
	elapsed_time += delta
	
	# Check if the object's lifetime has been exceeded
	if elapsed_time >= lifetime:
		queue_free()  # Destroy or remove the object
	#else:
		#print("Time left:", lifetime - elapsed_time)
