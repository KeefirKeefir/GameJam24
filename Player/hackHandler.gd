extends Node3D

@onready var Cam := get_parent().get_node("XPivot/Camera3D")
@onready var Hud := get_tree().get_nodes_in_group("HUD")[0]  
@onready var HTargets := Hud.get_node("HTargets")
@onready var HTargetName := Hud.get_node("HTarget/Name")
@onready var HHacks := Hud.get_node("Hacks")

#@onready var highlight := load("res://resources/highlight.tres")
@onready var themePanel :Panel= Hud.get_node("Panel")
@onready var styleBox: StyleBoxFlat = themePanel.get_theme_stylebox("panel")
@onready var highlight: StyleBoxFlat = themePanel.get_theme_stylebox("panel").duplicate()

@onready var HackPanel := preload("res://scenes/hackOnHud.tscn")

var focPanel :Node = null

var validEnemies : Array[Node] = []
var allTargets: Array[Node] = []
var target:Node = null

var hacking := false

var focused_index := 0

func _ready() -> void:
	pass

func detectEnemies() -> void:
	var center:Vector2= get_viewport().get_size() / 2
	
	for label in HTargets.get_children():
		HTargets.remove_child(label)
		label.queue_free()
	
	for enemy in validEnemies:
		var onScreenPos :Vector2 = Cam.unproject_position(enemy.position)
		
		var distanceFromCenter = center.distance_to(onScreenPos)
		if distanceFromCenter <= 150.0 and enemy not in allTargets:
			allTargets.append(enemy)
		elif distanceFromCenter >= 150.0 and enemy in allTargets:
			allTargets.erase(enemy)
			
	var closest_distance: float = INF
	
	for targetA in allTargets:
		var onScreenPos :Vector2 = Cam.unproject_position(targetA.position)
		var distanceFromCenter = center.distance_to(onScreenPos)
		if distanceFromCenter < closest_distance:
			closest_distance = distanceFromCenter
			target = targetA
				
	for targetA in allTargets:
		var tLabel := Label.new()
		tLabel.text = str(targetA.name)
		HTargets.add_child(tLabel)
	
	if target in allTargets:
		HTargetName.text = str(target.name)
	else: 
		HTargetName.text = ""

func hackMenu() -> void:
	for label in HHacks.get_children():
		HHacks.remove_child(label)
		label.queue_free()
		
	for hack in target.hacks:
		var tLabel := Label.new()
		var panel = Panel.new()
		
		var PanelInst := HackPanel.instantiate()
		HHacks.add_child(PanelInst)
		PanelInst.text = str(hack)
		
	if HHacks.get_child_count() > 0:
		HHacks.get_child(focused_index).highlight()

func _process(delta: float) -> void:
	detectEnemies()
		
	if hacking == true:
		Engine.time_scale = move_toward(Engine.time_scale, 0.01, 0.02)
	else:
		Engine.time_scale = move_toward(Engine.time_scale, 1.0, 0.02)
	
	#if hacking == true and target:
		#hackMenu()
	#elif target:
		#for label in HHacks.get_children():
			#HHacks.remove_child(label)
			#label.queue_free()

func _on_enemy_detection_body_entered(body: Node3D) -> void:
	validEnemies.append(body)
	print("new list:")
	for enemy in validEnemies:
		print(enemy.name)

func _on_enemy_detection_body_exited(body: Node3D) -> void:
	validEnemies.erase(body)
	allTargets.erase(body)
	if body == target:
		target = null
	print("new list:")
	for enemy in validEnemies:
		print(enemy.name)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("scrollDown"):
		focus_next_label()
	elif event.is_action_pressed("scrollUp"):
		focus_previous_label()
		
	if event.is_action_pressed("hack"):
		hacking = true
		if target:
			hackMenu()
	elif event.is_action_released("hack"):
		hacking = false
		for label in HHacks.get_children():
			HHacks.remove_child(label)
			label.queue_free()
	
func focus_next_label() -> void:
	if HHacks.get_child_count() == 0:
		return
	focused_index = (focused_index + 1) % HHacks.get_child_count()
	HHacks.get_child((focused_index - 1 + HHacks.get_child_count()) % HHacks.get_child_count()).deselect()
	HHacks.get_child(focused_index).highlight()
	#HHacks.get_child(focused_index).text = "false1"
	

func focus_previous_label() -> void:
	if HHacks.get_child_count() == 0:
		return
	focused_index = (focused_index - 1 + HHacks.get_child_count()) % HHacks.get_child_count()
	HHacks.get_child((focused_index + 1) % HHacks.get_child_count()).deselect()
	HHacks.get_child(focused_index).highlight()
	#HHacks.get_child(focused_index).highlight()


func hackState() -> void:
	pass
