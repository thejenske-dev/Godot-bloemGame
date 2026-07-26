extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
var walk_speed = round(randf_range(5.0,15.0))
var gowth_stage = 0
#Time it takes to eat a flower
var eating_speed = round(randf_range(5,10))
#The time it takes in a cocoon state
var cocoonTime = round(randf_range(10,30))
var die_time =  round(randf_range(10,30))
var target: Node2D = null 
var state = "egg"


#Amount of flowers a bug has eten
var eaten_flowers = 0
#Amount of flowers needed to be eaten before next stage
var growth_treshhold = round(randf_range(10,30))

var target_position: Vector2 = Vector2.ZERO
var rotation_speed: float = .2

var can_eat = true
var is_cocoon = false
var is_hatching = false
var has_eaten = false
var layed_egg = false
var is_flyingAway = false

#Preload bug script
var bug = preload("res://Scenes/bug.tscn")


@onready var animated_sprite_2d: AnimatedSprite2D = $Animated_Sprite_2d
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	return


func move_to(target:Node2D):
	#Set the target position of the navigation agent -> This will be the location of a flower
	navigation_agent_2d.target_position = target.global_position

func _physics_process(delta):
	match state:
		"egg":
			animated_sprite_2d.play("egg")
			if !is_hatching:
				is_hatching = true
				hatching()
		"find_target":
			can_eat = true
			match gowth_stage:
				1:
					animated_sprite_2d.play("Looking")
				3:
					animated_sprite_2d.play("Flying")
			
			match round(randf_range(0,1)):
				0.0:	
					find_random_target()
				1.0:
					find_closest_target()
		"moving":
			move_to_target()
			match gowth_stage:
				1:
					animated_sprite_2d.play("Walking")
				3:
					animated_sprite_2d.play("Flying")
			
		"doing_action":
					if can_eat:
						can_eat=false
						eat()
		"cocooning":
			if !is_cocoon:
				is_cocoon = true
				cocooning()
		"hatching":
			if !is_hatching:
				is_hatching = true
				hatching()
		"dying":
			if !is_flyingAway:
				print("Dying")
				is_flyingAway = true
				get_random_offscreen_point()
		



func find_closest_target():
	#Retreive all current flowers on screen
	var targets = get_tree().get_nodes_in_group("flower")
	#In case there are no flowers, do nothing
	if targets.is_empty():
		return
	#Get the nearest flower, relative to the bug
	target = get_nearest_object(targets)
	#Set the next target of the pathfinder agent to the position of the nearest found flower.
	navigation_agent_2d.target_position = target.global_position
	

	
	#Switch to the moving state.
	state = "moving"

func find_random_target():
	#Retreive all current flowers on screen
	var targets = get_tree().get_nodes_in_group("flower")
	#In case there are no flowers, do nothing
	if targets.is_empty():
		return
	#Get the nearest flower, relative to the bug
	target = get_random_object(targets)
	#Set the next target of the pathfinder agent to the position of the nearest found flower.
	navigation_agent_2d.target_position = target.global_position
	state = "moving"

func get_nearest_object(objects):
	#Init vars
	var nearest = null
	var closest_distance = INF
#Check around for objects and select the nearest one
	for obj in objects:
		#Set the distance of the found object
		var distance = global_position.distance_to(obj.global_position)
		#Check the distance to the current object, and if the distance
		#is closer then the current closest distance, overwrite the closest distance with the current found distance
		if distance < closest_distance:
			closest_distance = distance
			nearest = obj
	#To be checked if this code will lag the game when a lot of flowers are placed
	return nearest

#Find a random target
func get_random_object(objects):
	var selected = null
	#Total amount of objects
	var total_amount = objects.size()-1
	#Select a random object in the list
	selected = objects[round(randf_range(0,total_amount))]
	#print(selected)
	return selected
	

func get_random_offscreen_point():
	var rect = get_viewport().get_visible_rect()
	var margin = 5
	var destination
	
	match randi() % 4:
		0: #Top
			destination= Vector2(randf_range(0,rect.size.x),-margin)
		1: #Bottom
			destination= Vector2(randf_range(0,rect.size.x),rect.size.y +margin)
		2: #left
			destination= Vector2(-margin,randf_range(0,rect.size.y))
		3: #right
			destination= Vector2(rect.size.x + margin, randf_range(0, rect.size.y))
	
	navigation_agent_2d.target_position = destination
		#Make the sprite rotate smoothly
	state = "moving"
	
	
		
func move_to_target():
	#When the bug reached its destination, switcj to the state "doing action"
	if !is_instance_valid(target) and !is_flyingAway:
		state = "find_target"
	if navigation_agent_2d.is_navigation_finished()and !is_flyingAway:
		if !is_instance_valid(target):
				state = "find_target"
		state = "doing_action"
	if navigation_agent_2d.is_navigation_finished()and is_flyingAway:
		queue_free()
	#Get the next point on the path to the neares flower
	var next_point = navigation_agent_2d.get_next_path_position()
	#Set the direction correctly
	
		#Make the sprite rotate smoothly
	if is_instance_valid(target) and !is_flyingAway:
		var target_angle = (target.global_position - global_position).angle()
		rotation = rotate_toward(rotation, target_angle, rotation_speed)
	if is_instance_valid(target) and is_flyingAway:
		var target_angle = (navigation_agent_2d.target_position - global_position).angle()
		rotation = rotate_toward(rotation, target_angle, rotation_speed)
	
	
	var direction = (next_point - global_position).normalized()
	#Make the sprite rotate smoothly

	#look_at(global_position + direction)
	#Set the walkspeed
	velocity = direction * walk_speed
	#Move the sprite
	move_and_slide()

func eat():
	var current_target
	#Check if the flower is still there
	if is_instance_valid(target):
		current_target = target
	#Check if the flower is still there
	if is_instance_valid(current_target):
		#Depanding on the growth stage, play an animation (Refactor this so all action have their own code)
		match gowth_stage:
				1:
					animated_sprite_2d.play("Eating")
					await get_tree().create_timer(eating_speed).timeout
					if !is_instance_valid(current_target):
						state = "find_target"
				3: #Add a new animation where the butterfly polinates
					print("Nothing yet")
		#Check if the target flower is still there...			
	if is_instance_valid(current_target):
		#Get the current flower data
		var flowerdata = current_target.getFlower()
		match gowth_stage:
			#Depanding on the growth stage, do a different action
			1:
				#Set eaten to true for the flower
				current_target.setEaten(true)
				#Make the caterpillar color, the color of the leaves.
				$Animated_Sprite_2d.self_modulate = flowerdata[1]
				#Add 1 to the amound of flowers eaten
				eaten_flowers+=1
				#Incase an amount of flowers is eaten, make the caterpiller cocoon.
				if(eaten_flowers == growth_treshhold):
					state = "cocooning"
				else:
					state = "find_target"
			3:
				match round(randf_range(0,3)):
					0.0 , 1.0:
						#When already a butterfly, polinate the flowers
						current_target.setPolinated(true)
						print("Polinating..")
						state = "find_target"
					2.0,3.0:
						print("Lay_egg")
						lay_egg()
				
func cocooning():
	gowth_stage +=1
	animated_sprite_2d.play("Cocooning")
	await get_tree().create_timer(cocoonTime).timeout
	state = "hatching"
func hatching():
	gowth_stage +=1
	#print(gowth_stage)
	match gowth_stage:
		1: 
			await get_tree().create_timer(cocoonTime).timeout
			animated_sprite_2d.play("Looking")
		3:
			animated_sprite_2d.play("Hatching")
	is_hatching = false
	state = "find_target"	
	
func lay_egg():
	var current_target = null
	#Check if the target is valid
	if !is_instance_valid(target):
		state = "find_target"
	#When the target is valid, create an egg
	if is_instance_valid(target):
		current_target = target
		var new_bug = bug.instantiate()
		new_bug.position = target.global_position
		get_parent().add_child(new_bug)
		layed_egg = true
	if layed_egg:
		state = "dying"
	else:
		state = "find_target"
	
	#When a butterfly flyes over a flower, it can lay an egg on it.
	
	#When this is done, the butterfly will disapear after X amount of time
	return
