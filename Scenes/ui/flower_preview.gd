extends Control
var flowerColor_center = Color(0.898, 0.698, 0.149)
var flowerColor_leaves = Color(0.871, 0.161, 0.114)
@onready var flower: Node2D = $Panel/CenterContainer/Flower

#Needed to set flower after rest is done
signal setflower(center_color,leave_color,leave_part)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flower.changeColor(flowerColor_center,flowerColor_leaves)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func change_preview(center: Color, leaves: Color,part_sprite) -> void:
	flower.changeColor(center,leaves)
	flower.changeLeaves(part_sprite)

func getFlowerState() -> void:
	#Get the current flower state and set this in the flower manager
	#Need this to get the flower currently previed to the flower manager , after Reset action
	var flowerData = flower.getFlower()
	setflower.emit(flowerData[0],flowerData[1],flowerData[2])
