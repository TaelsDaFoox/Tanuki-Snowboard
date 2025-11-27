extends Control
@onready var promptLabels = [$QTE/Prompt1,$QTE/Prompt2,$QTE/Prompt3,$QTE/Prompt4,$QTE/Prompt5,$QTE/Prompt6,$QTE/Prompt7,$QTE/Prompt8]
var inputNames := ["Left","Right","Up","Down","Crouch"]
var promptTextures = [load("res://UI/Button Prompts/XboxSeriesX_Dpad_Left.png"),load("res://UI/Button Prompts/XboxSeriesX_Dpad_Right.png"),load("res://UI/Button Prompts/XboxSeriesX_Dpad_Up.png"),load("res://UI/Button Prompts/XboxSeriesX_Dpad_Down.png"),load("res://UI/Button Prompts/XboxSeriesX_A.png")]
var emptyTex := load("res://UI/Button Prompts/empty.png")
var QTEqueue := []
var QTElength := 8
var QTEprogress := 0
var QTEactive := false
@onready var QTEcontainer = $QTE
var linkedPlayer: CharacterBody3D

func _ready() -> void:
	QTEcontainer.visible = false

func QTEstart():
	QTEcontainer.visible=true
	QTEactive=true
	for i in QTElength:
		QTEqueue.append(randi_range(0,inputNames.size()-1))
		promptLabels[i].texture = promptTextures[QTEqueue[i]]

func _input(event: InputEvent) -> void:
	if QTEactive:
		if event.is_action_pressed(inputNames[QTEqueue[QTEprogress]]):
			promptLabels[QTEprogress].texture = emptyTex
			QTEprogress+=1
			if QTEprogress>=QTElength:
				QTEactive=false
				if linkedPlayer:
					linkedPlayer.tricked()
		else:
			pass #fail trick
