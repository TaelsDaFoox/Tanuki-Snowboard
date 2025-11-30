extends Control
@onready var promptLabels = [$QTE/Prompt1,$QTE/Prompt2,$QTE/Prompt3,$QTE/Prompt4,$QTE/Prompt5,$QTE/Prompt6,$QTE/Prompt7,$QTE/Prompt8]
var inputNames := ["Left","Right","Up","Down","Crouch"]
var promptTextures = [load("res://UI/Button Prompts/XboxSeriesX_Dpad_Left.png"),load("res://UI/Button Prompts/XboxSeriesX_Dpad_Right.png"),load("res://UI/Button Prompts/XboxSeriesX_Dpad_Up.png"),load("res://UI/Button Prompts/XboxSeriesX_Dpad_Down.png"),load("res://UI/Button Prompts/XboxSeriesX_A.png")]
var emptyTex := load("res://UI/Button Prompts/empty.png")
#var dirSFX := [load("res://Audio/Sfx/tricks/left.wav"),load("res://Audio/Sfx/tricks/right.wav"),load("res://Audio/Sfx/tricks/up.wav"),load("res://Audio/Sfx/tricks/down.wav"),load("res://Audio/Sfx/tricks/left.wav")]
#var trickedSFX := [load("res://Audio/Sfx/tricks/left-f.wav"),load("res://Audio/Sfx/tricks/right-f.wav"),load("res://Audio/Sfx/tricks/up-f.wav"),load("res://Audio/Sfx/tricks/down-f.wav"),load("res://Audio/Sfx/tricks/left-f.wav")]
@onready var sfx = $SFX
@onready var sfx2 = $SFX2
@onready var nopesfx = $nopeSFX
var QTEqueue := []
var QTElength := 8
var QTEprogress := 0
var QTEactive := false
@onready var QTEcontainer = $QTE
@onready var nopeTimer = $nopeTimer
@onready var nopeX = $nope
var linkedPlayer: CharacterBody3D

func _ready() -> void:
	QTEcontainer.visible = false

func QTEstart():
	for i in promptLabels.size():
		promptLabels[i].visible = i<QTElength
	sfx.pitch_scale=1.0-QTElength/10.0
	QTEcontainer.visible=true
	QTEactive=true
	QTEprogress=0
	QTEqueue.clear()
	for i in QTElength:
		QTEqueue.append(randi_range(0,inputNames.size()-1))
		promptLabels[i].texture = promptTextures[QTEqueue[i]]

func cancelQTE():
	QTEactive=false
	QTEcontainer.visible=false
func _process(delta: float) -> void:
	if QTEactive and not nopeTimer.is_stopped():
		nopeX.position = promptLabels[QTEprogress].global_position
		nopeX.scale = promptLabels[QTEprogress].scale
		nopeX.visible=true
	else:
		nopeX.visible=false
	
func QTEinput(input):
	if QTEactive and nopeTimer.is_stopped():
		if input.is_action_just_pressed(inputNames[QTEqueue[QTEprogress]]):
			promptLabels[QTEprogress].texture = emptyTex
			sfx.pitch_scale+=0.1
			QTEprogress+=1
			if QTEprogress>=QTElength:
				sfx2.play()
				#sfx.stream = trickedSFX[QTEqueue[QTEprogress-1]]
				QTEactive=false
				if linkedPlayer:
					linkedPlayer.tricked()
			else:
				pass
				#sfx.stream = dirSFX[QTEqueue[QTEprogress-1]]
			sfx.play()
		else:
			var anyInput = false
			for i in inputNames:
				if input.is_action_just_pressed(i):
					anyInput=true
					break
			if anyInput:
				nopesfx.play()
				nopeTimer.start()
