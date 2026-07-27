extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
var walk_speed = round(randf_range(5.0,15.0))
var gowth_stage = 0
#Time it takes to eat a flower
var eating_speed = round(randf_range(1,6))
#The time it takes in a cocoon state
var cocoonTime = round(randf_range(5,15))
#var die_time =  round(randf_range(10,30))
var target: Node2D = null 
var state = "egg"
var polination_time= round(randf_range(2,9))

#Amount of flowers a bug has eten
var eaten_flowers = 0
#Amount of flowers needed to be eaten before next stage
var growth_treshhold:int = round(randf_range(2,10))

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
			
			match randi()%2:
				0:	
					find_random_target()
				1:
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
			if !self.is_flyingAway:
				self.is_flyingAway = true
				self.get_random_offscreen_point()
		


func find_closest_target():
	var target_group =null
	#Depanding on the growth stage, decide which flowers are targeted.
	match gowth_stage:
		1: #Caterpillar
			target_group = "flower"
		3: #Butterfly
			if randi()%2 == 1:
				target_group = "flower"
			else:
				target_group = "polenated_flowers"
	#Retreive all current flowers on screen
	var targets = get_tree().get_nodes_in_group(target_group)
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
	var target_group =null
	#Depanding on the growth stage, decide which flowers are targeted.
	match gowth_stage:
		1:#Caterpillar
			target_group = "flower"
		3:#Butterfly
			if randi()%2 == 1:
				target_group = "flower"
			else:
				target_group = "polenated_flowers"
	#Retreive all current flowers on screen
	var targets = get_tree().get_nodes_in_group(target_group)
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
	
	self.navigation_agent_2d.target_position = destination
		#Make the sprite rotate smoothly
	self.state = "moving"
	
func move_to_target():
	if navigation_agent_2d.is_navigation_finished()and is_flyingAway:
		queue_free()
	#When the bug reached its destination, switcj to the state "doing action"
	if !is_instance_valid(target) and !is_flyingAway:
		state = "find_target"
	if navigation_agent_2d.is_navigation_finished()and !is_flyingAway:
		if !is_instance_valid(target):
				state = "find_target"
		state = "doing_action"

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
				1:#Caterpillar
					if is_instance_valid(current_target):
					#Check if the target is in the "flower" group
						if(current_target.get_groups().has("flower")):
							#Play eating animation
							animated_sprite_2d.play("Eating")
							await get_tree().create_timer(eating_speed).timeout
							if !is_instance_valid(current_target):
								state = "find_target"
								return
							#When done eating:
							if is_instance_valid(current_target):
								#Reteive the leave color of the eaten flower
								var flowerdata = current_target.getFlower()
								#Set the flower eaten state to true
								current_target.setEaten(true)
								#Make the caterpillar color, the color of the leaves.
								$Animated_Sprite_2d.self_modulate = flowerdata[1]
								#Add 1 to the amound of flowers eaten
								eaten_flowers+=1

								#When amount eaten flowers is treshhold, grow into cocoon
								if(eaten_flowers == growth_treshhold):
									
									state = "cocooning"
									return
					
						#When the flower is already eaten/polinated go somwhere else
					state = "find_target"
				3: #Butterlfy
					#Roll a random action value to determine what the butterfly will do.
					var action_chance = randi()%10+1
					
					#When the value is 1,2
					if action_chance <=1:
						
						#The butterfly will fly off screen
						state= "dying"
						return
					#When 3,4,5,6 then Polinate a flower
					if action_chance >=2 and action_chance<=6:
						
						#Check if the target still exists
						if is_instance_valid(current_target):
							#Check if a flower is already polinated?
							if(current_target.get_groups().has("polenated_flowers")):
								#Find another targer
								state = "find_target"
								return
							else: #Polinate the flower
								#Play animation
								animated_sprite_2d.play("Polinating")
								#Wait depanding on the polination time
								await get_tree().create_timer(polination_time).timeout
								#Check if the flower still exists
								if is_instance_valid(current_target):
									#Set the flower polination flag to true
									current_target.setPolinated(true)
							#When done,go to somwhere else
							state = "find_target"
							return
					#When 7,8,9,10 : Lay an egg if the targer is a polenated flower
					if action_chance >=7 and action_chance<=10:
					
						#Check if the target still exists
						if is_instance_valid(current_target):
							if(current_target.get_groups().has("polenated_flowers")):
								#Only lay an egg on a polinated flower, then remove polination
								#Check if the flower target still exists
								if is_instance_valid(current_target):
									#Set polinated to false for the target flower
									current_target.setPolinated(false)
									#Lay the egg
									lay_egg()
									return
					state ="find_target"

func cocooning():
	gowth_stage +=1
	animated_sprite_2d.play("Cocooning")
	await get_tree().create_timer(cocoonTime).timeout
	state = "hatching"
func hatching():
	gowth_stage +=1
	match gowth_stage:
		1: 
			await get_tree().create_timer(cocoonTime).timeout
			self.z_index +=10
			animated_sprite_2d.play("Looking")
		3:
			self.z_index +=10
			self.walk_speed+=1
			animated_sprite_2d.play("Hatching")
			
	is_hatching = false
	state = "find_target"	
func lay_egg():
	var current_target = null
	#Check if the target is valid
	if !is_instance_valid(target):
		state = "find_target"
		return
	#When the target is valid, create an egg
	if is_instance_valid(target):
		current_target = target
		var new_bug = bug.instantiate()
		new_bug.position = current_target.global_position
		get_parent().add_child(new_bug)
		layed_egg = true
		current_target.setHoldsEgg(true)
	if layed_egg:
		state = "dying"
		return
	else:
		state = "find_target"
		return
	
