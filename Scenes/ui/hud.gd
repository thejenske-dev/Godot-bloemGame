extends CanvasLayer
@onready var flower_preview_panel: Control = $Flower_preview_panel
@onready var flower_manager: Node2D = $"../FlowerManager"
@onready var save_flower: Control = $Save_Flower


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_flower_manager_update_preview(center_color: Variant, leave_color: Variant, leave_part: Variant) -> void:
	#Comes form the flower manager -> Will update the preview flower
	flower_preview_panel.change_preview(center_color, leave_color,leave_part)


func _on_save_flower_setflower(center_color: Variant, leave_color: Variant, leave_part: Variant) -> void:
	#Comes from the saved flower UI element -> Will set the current flower in the manager
	flower_manager.setFlower(center_color,leave_color,leave_part)


func _on_flower_manager_save_flower(center_color: Variant, leave_color: Variant, leave_part: Variant) -> void:
	#Comes form manager -> To save flower UI element, to save
	save_flower.saveFlowerState(center_color,leave_color,leave_part)
