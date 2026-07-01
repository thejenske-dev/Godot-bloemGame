extends CenterContainer
@onready var flower: Node2D = $Panel/CenterContainer/Flower
@onready var flower_leaves: Sprite2D = $flower_leaves
@onready var flower_center: Sprite2D = $flower_center


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func change_preview(leaves: Color, center: Color) -> void:
	flower_leaves.self_modulate = leaves
	flower_center.self_modulate = center
	

func _on_flower_flower_color_changed(leaves: Color, center: Color) -> void:
	flower_leaves.self_modulate = leaves
	flower_center.self_modulate = center
	
