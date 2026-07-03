extends Control
@onready var flower: Node2D = $HBoxContainer/Button/Flower
signal setflower(center_color,leave_color,leave_part)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	setFlowerState()


func saveFlowerState(center,leaves,leaves_sprite) -> void:
	#Change the flower in the picture to the current state it is in.
	#This will be done by pressing the "1" key.
	flower.changeColor(center,leaves)
	flower.changeLeaves(leaves_sprite)
	
func setFlowerState() -> void:
	#Get the current flower state and set this in the flower manager
	#This happens when the button is pressed
	var flowerData = flower.getFlower()
	setflower.emit(flowerData[0],flowerData[1],flowerData[2])
	
	
