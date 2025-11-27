extends HBoxContainer
@onready var promptLabels = [$Prompt1,$Prompt2,$Prompt3,$Prompt4,$Prompt5,$Prompt6,$Prompt7,$Prompt8]
var inputNames := ["Left","Right","Up","Down","Crouch"]
var promptTextures = [load("res://UI/Button Prompts/XboxSeriesX_Dpad_Left.png"),load("res://UI/Button Prompts/XboxSeriesX_Dpad_Right.png"),load("res://UI/Button Prompts/XboxSeriesX_Dpad_Up.png"),load("res://UI/Button Prompts/XboxSeriesX_Dpad_Down.png"),load("res://UI/Button Prompts/XboxSeriesX_A.png")]
var emptyTex := load("res://UI/Button Prompts/empty.png")
var QTEqueue := []
var QTElength := 8

func _ready() -> void:
	for i in QTElength:
		QTEqueue.append(randi_range(0,inputNames.size()-1))
		promptLabels[i].texture = promptTextures[QTEqueue[i]]
	
	print(QTEqueue)
