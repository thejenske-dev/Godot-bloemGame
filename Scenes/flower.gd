extends Node2D

var leave_texture = load("res://graphics/Flowers/Grayscale_flowerLeaves.png")
@onready var sound_delete_flower: AudioStreamPlayer2D = $sound_delete_flower
@onready var delete_flower: CPUParticles2D = $delete_flower
@onready var star_sparkle: CPUParticles2D = $star_sparkle
@onready var pollen: CPUParticles2D = $pollen

var eaten: bool = false
var polinated: bool = false
var regrow_time = 30


var shinyLock = true


signal flowerColorChanged(leaves:Color,center:Color)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(shinyLock == false):
		checkShiny()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if eaten: 
		$Flower_leaves.visible = false
	else:
		$Flower_leaves.visible = true


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
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_MIDDLE and event.pressed:
		print("Clicked flower!")
		
		#var uid = ResourceUID.id_to_text(ResourceLoader.get_resource_uid($Flower_leaves.texture.resource_path))
		var flowerData = self.getFlower()
		var flower_manager = get_parent().get_parent()
		flower_manager.setFlower(flowerData[0],flowerData[1],flowerData[2])
		
		
		
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

func setEaten(state:bool):
	self.eaten = state
	self.remove_from_group("flower")
	self.add_to_group("eaten_flower")
	await get_tree().create_timer(regrow_time).timeout
	self.remove_from_group("eaten_flower")
	self.add_to_group("flower")
	self.eaten = false

func setPolinated(state:bool):
	self.polinated = state
	self.remove_from_group("flower")
	
	self.add_to_group("polenated_flowers")
	#Change in the future
	pollen.self_modulate = $Flower_center.self_modulate
	pollen.emitting = true
