extends CanvasLayer
@onready var flower_manager: Node2D = $"../FlowerManager"
@onready var save_flower: Control = $VBoxContainer2/HBoxContainer/Save_Flower
@onready var save_flower_2: Control = $VBoxContainer2/HBoxContainer/Save_Flower2
@onready var save_flower_3: Control = $VBoxContainer2/HBoxContainer/Save_Flower3
@onready var flower_preview_panel: Control = $VBoxContainer/Flower_preview_panel
@onready var save_flower_4: Control = $VBoxContainer2/HBoxContainer/Save_Flower4
@onready var save_flower_5: Control = $VBoxContainer2/HBoxContainer/Save_Flower5
@onready var save_flower_6: Control = $VBoxContainer2/HBoxContainer/Save_Flower6


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


func _on_flower_manager_save_flower(center_color: Variant, leave_color: Variant, leave_part: Variant, slot:int) -> void:
	#Comes form manager -> To save flower UI element, to save
	match slot:
		1:
			save_flower.saveFlowerState(center_color,leave_color,leave_part)
		2:
			save_flower_2.saveFlowerState(center_color,leave_color,leave_part)
		3:
			save_flower_3.saveFlowerState(center_color,leave_color,leave_part)
		4:
			save_flower_4.saveFlowerState(center_color,leave_color,leave_part)
		5:
			save_flower_5.saveFlowerState(center_color,leave_color,leave_part)
		6:
			save_flower_6.saveFlowerState(center_color,leave_color,leave_part)	


func _on_save_flower_2_setflower(center_color: Variant, leave_color: Variant, leave_part: Variant) -> void:
	#Comes from the saved flower UI element -> Will set the current flower in the manager
	flower_manager.setFlower(center_color,leave_color,leave_part)

func _on_save_flower_3_setflower(center_color: Variant, leave_color: Variant, leave_part: Variant) -> void:
	#Comes from the saved flower UI element -> Will set the current flower in the manager
	flower_manager.setFlower(center_color,leave_color,leave_part)

func _on_save_flower_4_setflower(center_color: Variant, leave_color: Variant, leave_part: Variant) -> void:
	#Comes from the saved flower UI element -> Will set the current flower in the manager
	flower_manager.setFlower(center_color,leave_color,leave_part)

func _on_save_flower_5_setflower(center_color: Variant, leave_color: Variant, leave_part: Variant) -> void:
	#Comes from the saved flower UI element -> Will set the current flower in the manager
	flower_manager.setFlower(center_color,leave_color,leave_part)

func _on_save_flower_6_setflower(center_color: Variant, leave_color: Variant, leave_part: Variant) -> void:
	#Comes from the saved flower UI element -> Will set the current flower in the manager
	flower_manager.setFlower(center_color,leave_color,leave_part)
