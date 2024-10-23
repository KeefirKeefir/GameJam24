extends Label

var fps
#set max fps in project setting, currently uncapped and vsync disabled

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	fps = Engine.get_frames_per_second()
	text = "FPS: " + str(fps)
