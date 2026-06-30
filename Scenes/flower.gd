extends Node2D

signal flowerColorChanged(leaves:Color,center:Color)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		# Check if the event is a mouse click and the left mouse button was pressed
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT and event.pressed:
		print("pressed!")
		# Removes the scene/node from the game safely
		queue_free() # Replace with function body.

func changeColor(Center:Color,Leaves:Color) -> void:
	$Flower_leaves.self_modulate = Leaves
	$Flower_center.self_modulate = Center
	flowerColorChanged.emit(Center,Leaves)
	
