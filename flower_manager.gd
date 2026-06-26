extends Node2D
var flower = preload("res://Scenes/flower.tscn")
var m_pos:Vector2
var reset_active:bool = false
var flowercolours_pos = 0
var flower_center_rgb = [0.957,0.173,0.502]
var flower_leaves_rgb = [0.789, 0.623, 0.094]
var flowerColor_center = Color(0.957,0.173,0.502)
var flowerColor_leaves = Color(0.789, 0.623, 0.094)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Left_Click")):
		var new_flower = flower.instantiate()
		print(m_pos)
		var flower_pos = Vector2(get_global_mouse_position())
		new_flower.position = flower_pos
		new_flower.changeColor(flowerColor_center,flowerColor_leaves)
		print("Center:" , flowerColor_center)
		print("Leaves:" , flowerColor_leaves)
		add_child(new_flower)
		
		
		
	#Resetting the garden and deletes all child flowers
	if(Input.is_action_just_pressed("Reset") and reset_active == false ):
		reset_active = true
		var delay=.1
		print("Reset")
		if self.get_children()!= null:
			for scene in self.get_children():
				await get_tree().create_timer(delay).timeout
				scene.queue_free()
				delay -=.01
			reset_active = false 
		else:
			print("No flowers :)")
	#Changing flower colours
	if(Input.is_action_just_pressed("arrow_up") or Input.is_action_just_pressed("Scroll_up") ):
		#Change flower colour sprite
		setColors()
		print("arrow_up pressed")
	
	if(Input.is_action_just_pressed("arrow_down") or Input.is_action_just_pressed("Scroll_down")):
		setColors()
		print("arrow_down pressed")		
func setColors() -> void:
	for i in range(flower_center_rgb.size()):
		var randnr_cent = randf_range(0,1)
		flower_center_rgb.set(i,randnr_cent)
		print(i)
		
	for x in range(flower_leaves_rgb.size()):
		var randnr_leave = randf_range(0,1)
		flower_leaves_rgb.set(x, randnr_leave)
		
	flowerColor_center = Color(flower_center_rgb[0],flower_center_rgb[1],flower_center_rgb[2])
	flowerColor_leaves = Color(flower_leaves_rgb[0],flower_leaves_rgb[1],flower_center_rgb[2])
		
	
