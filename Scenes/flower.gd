extends Node2D

var leave_texture = load("res://graphics/Flowers/Grayscale_flowerLeaves.png")
@onready var sound_delete_flower: AudioStreamPlayer2D = $sound_delete_flower
@onready var delete_flower: CPUParticles2D = $delete_flower
@onready var star_sparkle: CPUParticles2D = $star_sparkle
var shinyLock = true


signal flowerColorChanged(leaves:Color,center:Color)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(shinyLock == false):
		checkShiny()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		# Check if the event is a mouse click and the left mouse button was pressed
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT and event.pressed:
		#Play deletion sound
		sound_delete_flower.play()
		
		#Setting and playing partcles
		delete_flower.texture = leave_texture
		delete_flower.self_modulate = $Flower_leaves.self_modulate
		delete_flower.emitting=true
		#Wait until the sound is done playing
		await sound_delete_flower.finished
		# Removes the scene/node from the game safely
		queue_free() # Replace with function body.
	#if(Input.is_action_just_pressed("Right_Click")):
		
func changeColor(Center:Color,Leaves:Color) -> void:

	$Flower_center.self_modulate = Center
	$Flower_leaves.self_modulate = Leaves
	

	#flowerColorChanged.emit(Center,Leaves)
func changeLeaves(part_sprite) -> void:
	leave_texture = load(part_sprite)
	$Flower_leaves.texture = leave_texture
	
func getFlower():
	var uid = ResourceUID.id_to_text(ResourceLoader.get_resource_uid($Flower_leaves.texture.resource_path))
	return [$Flower_center.self_modulate,$Flower_leaves.self_modulate, uid]

func checkShiny():
	if(round(randf_range(0,100)) == 1):
		var center = $Flower_center.self_modulate
		var leaves = $Flower_leaves.self_modulate
		#Revert colors
		$Flower_center.self_modulate = leaves
		$Flower_leaves.self_modulate = center
		
		star_sparkle.self_modulate = $Flower_center.self_modulate
		star_sparkle.emitting = true
		
func setShinyLock(state:bool):
	shinyLock = state
