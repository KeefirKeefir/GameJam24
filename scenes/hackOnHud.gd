extends Label

@onready var panel := $Panel
var myhack:h.data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func highlight() -> void:
	panel.visible = true

func deselect() -> void:
	panel.visible = false
