extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
var walk_speed = 10.0
var gowth_stage = 0
var eating_speed = 1
var target: Node2D = null 
var state = "find_target"
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
		"find_target":
			find_closest_target()
		"moving":
			move_to_target()
		"doing_action":
			eat()



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


func move_to_target():
	#When the bug reached its destination, switcj to the state "doing action"
	if navigation_agent_2d.is_navigation_finished():
		if !is_instance_valid(target):
				state = "find_target"
		state = "doing_action"
	#Get the next point on the path to the neares flower
	var next_point = navigation_agent_2d.get_next_path_position()
	#Set the direction correctly
	var direction = (next_point - global_position).normalized()
	#Set the walkspeed
	velocity = direction * walk_speed
	#Move the sprite
	move_and_slide()



func eat():
	var current_target
	if is_instance_valid(target):
		current_target = target
	if is_instance_valid(current_target):
		await get_tree().create_timer(eating_speed).timeout
	if is_instance_valid(current_target):
		current_target.setEaten(true)
	state = "find_target"
