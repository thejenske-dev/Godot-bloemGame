extends Control
@onready var flower_leaves: Sprite2D = $Panel/CenterContainer/flower_leaves
@onready var flower_center: Sprite2D = $Panel/CenterContainer/flower_center
var flowerColor_center = Color(0.957,0.173,0.502)
var flowerColor_leaves = Color(0.789, 0.623, 0.094)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flower_leaves.self_modulate = flowerColor_leaves
	flower_center.self_modulate = flowerColor_center


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func change_preview(center: Color, leaves: Color) -> void:
	flower_leaves.self_modulate = leaves
	flower_center.self_modulate = center
