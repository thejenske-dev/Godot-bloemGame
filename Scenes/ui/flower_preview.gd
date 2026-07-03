extends Control
var flowerColor_center = Color(0.957,0.173,0.502)
var flowerColor_leaves = Color(0.789, 0.623, 0.094)
@onready var flower: Node2D = $Panel/CenterContainer/Flower

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flower.changeColor(flowerColor_center,flowerColor_leaves)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func change_preview(center: Color, leaves: Color,part_sprite) -> void:
	flower.changeColor(center,leaves)
	flower.changeLeaves(part_sprite)
