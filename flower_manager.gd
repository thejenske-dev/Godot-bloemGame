extends Node2D
#Preload the flower scene
var flower = preload("res://Scenes/flower.tscn")
#Flower position
var m_pos:Vector2
#Reset active flag
var reset_active:bool = false
#The to be colors of the flower
var flower_center_rgb = [0.957,0.173,0.502]
var flower_leaves_rgb = [0.789, 0.623, 0.094]
#The current colors of the flower
var flowerColor_center = Color(0.957,0.173,0.502)
var flowerColor_leaves = Color(0.789, 0.623, 0.094)
@onready var control: Control = $"../Control"

#All leave sprites ID's
var leave_parts = ["uid://bq7v55wivk1y8","uid://dgxd2kcujjq1k","uid://ftdwa4k85otq"]
var current_leave_id = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#When you left click, a new flower will spawn at mouse location.
	if(Input.is_action_just_pressed("Left_Click")):
		#Creata a new flower scene
		var new_flower = flower.instantiate()
		#Set the flower position to the mouses position
		var flower_pos = Vector2(get_global_mouse_position())
		new_flower.position = flower_pos
		#Set the color of the flower
		new_flower.changeColor(flowerColor_center,flowerColor_leaves)
		new_flower.changeLeaves(leave_parts[current_leave_id])
		#Add the new flower to the node tree.
		add_child(new_flower)
		
		
	#Resetting the garden and deletes all child flowers
	if(Input.is_action_just_pressed("Reset") and reset_active == false ):
		reset_active = true
		#The time between the deletion of flowers.
		var delay=.1
		if self.get_children()!= null:
			for scene in self.get_children():
				await get_tree().create_timer(delay).timeout
				scene.queue_free()
				delay -=.01
			reset_active = false 
		else:
			print("No flowers :)")
			
	#Changing flower colors
	if(Input.is_action_just_pressed("arrow_up") or Input.is_action_just_pressed("Scroll_up") ):
		#Changes both sprites
		setColors()
		#Change the UI preview flowers color
		control.change_preview(flowerColor_center,flowerColor_leaves,leave_parts[current_leave_id])
		
	
	if(Input.is_action_just_pressed("arrow_down") or Input.is_action_just_pressed("Scroll_down")):
		#Changes both sprites
		setColors()
		#Change the UI preview flowers color
		control.change_preview(flowerColor_center,flowerColor_leaves,leave_parts[current_leave_id])
		
	if(Input.is_action_just_pressed("arrow_left")):
		#Pick the next sprite in the dictionairy
		if(current_leave_id < leave_parts.size()-1):
			current_leave_id+=1
			control.change_preview(flowerColor_center,flowerColor_leaves,leave_parts[current_leave_id])
	if(Input.is_action_just_pressed("arrow_right")):
		#Pick the next sprite in the dictionairy
		if(current_leave_id > 0):
			current_leave_id-=1
			control.change_preview(flowerColor_center,flowerColor_leaves,leave_parts[current_leave_id])
			
		#Call Change leaves function and pass the sprite location
		pass
			
		
func setColors() -> void:
	#Sets the 3 color values to a randomized value between 0 and 1
	for i in range(flower_center_rgb.size()):
		var randnr_cent = randf_range(0,1)
		flower_center_rgb.set(i,randnr_cent)
		#print(i)
	#Sets the 3 color values to a randomized value between 0 and 1	
	for x in range(flower_leaves_rgb.size()):
		var randnr_leave = randf_range(0,1)
		flower_leaves_rgb.set(x, randnr_leave)
	#Set the flower color vars with the new randomizes values
	flowerColor_center = Color(flower_center_rgb[0],flower_center_rgb[1],flower_center_rgb[2])
	flowerColor_leaves = Color(flower_leaves_rgb[0],flower_leaves_rgb[1],flower_center_rgb[2])
		
	
