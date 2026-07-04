extends Node2D

var leaves = ["uid://bq7v55wivk1y8","uid://dgxd2kcujjq1k"]
@onready var test_leave: Sprite2D = $Test_leave

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var sprite = load(leaves[1])
	$Test_leave.texture = sprite
