extends Node2D
#Preload the flower scene
var flower = preload("res://Scenes/flower.tscn")

#Preload Bug scene
var bug = preload("res://Scenes/bug.tscn")


#Flower position
var m_pos:Vector2
#Reset active flag
var reset_active:bool = false
#The to be colors of the flower
var flower_center_rgb = [0.898, 0.698, 0.149]
var flower_leaves_rgb = [0.871, 0.161, 0.114]
#The current colors of the flower
var flowerColor_center = Color(0.898, 0.698, 0.149)
var flowerColor_leaves = Color(0.871, 0.161, 0.114)
@onready var control: Control = $"../Control"
@onready var hud: CanvasLayer = $"../HUD"

#Sound
#Deltion pitch fluctuations handling
var del_max_pitch = 2
var del_min_pith = 0.5
var sound_state = "up"

#Placing pitch fluctuations to create the random sounds
var pl_max_pitch = 0.9
var pl_min_pith = 0.3


@onready var sound_place_flower: AudioStreamPlayer2D = $Sound/sound_place_flower
@onready var sound_delete_flower: AudioStreamPlayer2D = $Sound/sound_delete_flower

#All leave sprites ID's
var leave_parts = ["uid://bq7v55wivk1y8","uid://dgxd2kcujjq1k","uid://ftdwa4k85otq"]
var current_leave_id = 0
var laeve_part = leave_parts[0]

#Particals
@onready var place_flower: CPUParticles2D = $Particles/place_flower
@onready var delete_flower_all: CPUParticles2D = $Particles/delete_flower_all
var mouse_pos =  Vector2(get_global_mouse_position())

signal update_preview(center_color,leave_color,leave_part)
signal save_flower(center_color,leave_color,leave_part,slot)

#Bugs
var bugs_chance = 50


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RandomSaveSlots()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Track mouse
	mouse_pos =  Vector2(get_global_mouse_position())
	#When you left click, a new flower will spawn at mouse location.
	if(Input.is_action_just_pressed("Left_Click")):
		var click_delay =.1
		if get_viewport().gui_get_hovered_control() != null:
			return # Mouse is over UI, ignore world click
		while (Input.is_action_pressed("Left_Click")):
			placeFlower()
			if (round(randf_range(0,bugs_chance))==1):
				placeBug()
			await get_tree().create_timer(click_delay).timeout
	
		
	

		
	#Resetting the garden and deletes all child flowers
	if(Input.is_action_just_pressed("Reset") and reset_active == false ):
		reset()
	#Changing flower colors
	if(Input.is_action_just_pressed("arrow_up") or Input.is_action_just_pressed("Scroll_up") ):
		#Changes both sprites
		print("scrolled")
		setColors()
		#Change the UI preview flowers color
		#control.change_preview(flowerColor_center,flowerColor_leaves,leave_parts[current_leave_id])
		update_preview.emit(flowerColor_center,flowerColor_leaves,laeve_part)
		
	if(Input.is_action_just_pressed("arrow_down") or Input.is_action_just_pressed("Scroll_down")):
		#Changes both sprites
		setColors()
		#Change the UI preview flowers color
		#control.change_preview(flowerColor_center,flowerColor_leaves,leave_parts[current_leave_id])
		update_preview.emit(flowerColor_center,flowerColor_leaves,laeve_part)
		
	if(Input.is_action_just_pressed("arrow_left")):
		#Pick the next sprite in the dictionairy
		if(current_leave_id == leave_parts.size()-1):
			current_leave_id =0
		elif(current_leave_id < leave_parts.size()-1):
			current_leave_id+=1
		laeve_part = leave_parts[current_leave_id]
		#control.change_preview(flowerColor_center,flowerColor_leaves,leave_parts[current_leave_id])
		update_preview.emit(flowerColor_center,flowerColor_leaves,laeve_part)
			
	if(Input.is_action_just_pressed("arrow_right")):
		#Pick the next sprite in the dictionairy
		if(current_leave_id == 0):
			current_leave_id = leave_parts.size()-1
		elif(current_leave_id > 0):
			current_leave_id-=1
		
		laeve_part = leave_parts[current_leave_id]
		#control.change_preview(flowerColor_center,flowerColor_leaves,leave_parts[current_leave_id])
		update_preview.emit(flowerColor_center,flowerColor_leaves,laeve_part)





	#Save slot logic
	if(Input.is_action_just_pressed("Numpad_1")or Input.is_action_just_pressed("Main_1")):
		#set the current flower state into the saved slot.
		save_flower.emit(flowerColor_center,flowerColor_leaves,laeve_part,1)
	
	if(Input.is_action_just_pressed("Numpad_2")or Input.is_action_just_pressed("Main_2")):
		#set the current flower state into the saved slot.
		save_flower.emit(flowerColor_center,flowerColor_leaves,laeve_part,2)
		
	if(Input.is_action_just_pressed("Numpad_3")or Input.is_action_just_pressed("Main_3")):
		#set the current flower state into the saved slot.
		save_flower.emit(flowerColor_center,flowerColor_leaves,laeve_part,3)
	
	if(Input.is_action_just_pressed("Numpad_4")or Input.is_action_just_pressed("Main_4")):
		#set the current flower state into the saved slot.
		save_flower.emit(flowerColor_center,flowerColor_leaves,laeve_part,4)
		
	if(Input.is_action_just_pressed("Numpad_5")or Input.is_action_just_pressed("Main_5")):
		#set the current flower state into the saved slot.
		save_flower.emit(flowerColor_center,flowerColor_leaves,laeve_part,5)
		
	if(Input.is_action_just_pressed("Numpad_6")or Input.is_action_just_pressed("Main_6")):
		#set the current flower state into the saved slot.
		save_flower.emit(flowerColor_center,flowerColor_leaves,laeve_part,6)	
		
func reset():
	#Makes sure you cannot reset while resetting.
	reset_active = true
		
	#Setting particles:
	#Genarate a random sprite
	delete_flower_all.texture = load(leave_parts[round(randf_range(0,leave_parts.size()-1))])
	delete_flower_all.self_modulate = flowerColor_leaves
	delete_flower_all.position = mouse_pos
	delete_flower_all.emitting = true
		
		#The time between the deletion of flowers.
	var delay=.1
	if $Flowers.get_children()!= null:
		for scene in $Flowers.get_children():
				
			await get_tree().create_timer(delay).timeout
			#Define if the deletion sounds goes up or down
			if(sound_delete_flower.pitch_scale >= del_max_pitch and sound_state == "up"):
				sound_state = "down"
			if(sound_delete_flower.pitch_scale <= del_min_pith and sound_state == "down"):
				sound_state = "up"
			#manipulate the pitch by a specific step	
			if (sound_state == "up"):
				sound_delete_flower.pitch_scale +=0.1
			if (sound_state == "down"):
				sound_delete_flower.pitch_scale -=0.1
			#Create new random particle
			setColors()
			delete_flower_all.self_modulate = flowerColor_leaves
			delete_flower_all.texture = load(leave_parts[round(randf_range(0,leave_parts.size()-1))])
			delete_flower_all.position = mouse_pos
			#Play the sound
			sound_delete_flower.play()
			scene.queue_free()
			#Make the delay go down so flowers will be removed faster and faster.
			delay -=.01
		reset_active = false
		delete_flower_all.emitting = false
			
		hud.getPreviewFlower()
			#flowerColor_center = saved_center_color
			#flowerColor_leaves = saved_leave_color
			#leave_parts = saved_leave_part
		
	else:
		return
			
			
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
	
func setFlower(center,leaves,leave_sprite) -> void:
		flowerColor_center = center
		flowerColor_leaves = leaves
		laeve_part = leave_sprite
		update_preview.emit(flowerColor_center,flowerColor_leaves,laeve_part)

func changeLeaves():
	if(current_leave_id == 0):
		current_leave_id = leave_parts.size()-1
	elif(current_leave_id > 0):
		current_leave_id-=1
	laeve_part = leave_parts[current_leave_id]
		#control.change_preview(flowerColor_center,flowerColor_leaves,leave_parts[current_leave_id])
	update_preview.emit(flowerColor_center,flowerColor_leaves,laeve_part)

func getFlower():
	var flower_data = [flowerColor_center,flowerColor_leaves,laeve_part]
	return flower_data

func setParticles(color,sprite) -> void:
	var texture = load(sprite)
	place_flower.texture = texture
	place_flower.self_modulate = color

func placeFlower() -> void: 
	#Creata a new flower scene
	var new_flower = flower.instantiate()
	#Set the flower position to the mouses position
	var flower_pos = Vector2(get_global_mouse_position())
	new_flower.position = flower_pos
		
	#Set the color of the flower
	new_flower.changeColor(flowerColor_center,flowerColor_leaves)
	new_flower.changeLeaves(laeve_part)
	new_flower.setShinyLock(false)
	#Set particles
	setParticles(flowerColor_leaves,laeve_part)
	place_flower.position = flower_pos
	place_flower.emitting = true
	#Play the placing sound, with a random range pitch
	sound_place_flower.pitch_scale = randf_range(pl_min_pith,pl_max_pitch)
	sound_place_flower.play()
	new_flower.add_to_group("flower")
	#Add the new flower to the node tree
	$Flowers.add_child(new_flower)

func placeBug() -> void:
	var new_bug = bug.instantiate()
	var bug_pos = Vector2(get_global_mouse_position())
	new_bug.position = bug_pos
	$Bugs.add_child(new_bug)

func RandomSaveSlots() -> void:
	pass
	#Loop x times
	var x = 7
	#Define a local leave ID
	var leave_id = round(randf_range(0,leave_parts.size()-1))
	for i in range(x):
		#Call the color randomize function
		setColors()
		#Randomize the leave ID
		leave_id = round(randf_range(0,leave_parts.size()-1))
		#Set the leave sprite ID
		laeve_part = leave_parts[leave_id]
		#Save the flower to the current save flower UI element
		save_flower.emit(flowerColor_center,flowerColor_leaves,laeve_part,i)	
		#Incremen the loop var
		i+=1
	#When done, update the preview to the correct flower in the manager.
	update_preview.emit(flowerColor_center,flowerColor_leaves,laeve_part)
		
	#Go through all the available save slots
	#Set the color of a flower
	#Set the leaves of a flower
	#Save the flower
	
