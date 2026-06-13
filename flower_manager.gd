extends Node2D
var flower = preload("res://Scenes/flower.tscn")
var m_pos:Vector2
var reset_active:bool = false
var flowercolours_pos = 0
var flowercolours = [0,0,0]
var flowerColor : Color

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
		new_flower.changeColor(flowerColor)
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
	if(Input.is_action_just_pressed("arrow_up")):
		#Change flower colour sprite
		if(flowercolours_pos <2):
			flowercolours_pos +=1
			flowercolours[flowercolours_pos] = 1
		else:
			flowercolours_pos =0
			flowercolours[flowercolours_pos] = 1
		flowerColor = Color(flowercolours[0],flowercolours[1],flowercolours[2])
		print("arrow_up pressed")
	if(Input.is_action_just_pressed("arrow_down")):
		#Change flower colour sprite
		if(flowercolours_pos >0):
			flowercolours_pos -=1
			flowercolours[flowercolours_pos] = 0
		else:
			flowercolours_pos =2
			flowercolours[flowercolours_pos] = 0
		flowerColor = Color(flowercolours[0],flowercolours[1],flowercolours[2])
		print("arrow_down pressed")		
