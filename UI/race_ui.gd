extends Control
@onready var promptLabels = [$QTE/Prompt1,$QTE/Prompt2,$QTE/Prompt3,$QTE/Prompt4,$QTE/Prompt5,$QTE/Prompt6,$QTE/Prompt7,$QTE/Prompt8]
var inputNames := ["Left","Right","Up","Down","Crouch"]
var promptTextures = [load("res://UI/Button Prompts/ArrowL.png"),load("res://UI/Button Prompts/ArrowR.png"),load("res://UI/Button Prompts/ArrowU.png"),load("res://UI/Button Prompts/ArrowD.png"),load("res://UI/Button Prompts/Button.png")]
var emptyTex := load("res://UI/Button Prompts/empty.png")
#var dirSFX := [load("res://Audio/Sfx/tricks/left.wav"),load("res://Audio/Sfx/tricks/right.wav"),load("res://Audio/Sfx/tricks/up.wav"),load("res://Audio/Sfx/tricks/down.wav"),load("res://Audio/Sfx/tricks/left.wav")]
#var trickedSFX := [load("res://Audio/Sfx/tricks/left-f.wav"),load("res://Audio/Sfx/tricks/right-f.wav"),load("res://Audio/Sfx/tricks/up-f.wav"),load("res://Audio/Sfx/tricks/down-f.wav"),load("res://Audio/Sfx/tricks/left-f.wav")]
@onready var sfx = $SFX
@onready var sfx2 = $SFX2
@onready var nopesfx = $nopeSFX
var QTEqueue := []
var QTElength := 4
var QTEprogress := 0
var QTEactive := false
@onready var QTEcontainer = $QTE
@onready var nopeTimer = $nopeTimer
@onready var nopeX = $nope
var linkedPlayer: CharacterBody3D
@onready var placementLabel = $PlacementLabel
var awesometext = ["GROOVY!","THAT'S IT!","LET'S MAKE IT!!","WON'T STOP!","FUNKY!","LET'S GO!","DON'T BLINK","MOVE IT!!","ONLY FORWARDS","DON'T STOP NOW"]
var placementEndings := ["th","st","nd","rd","th","th","th","th","th","th",]
@onready var finishedHeader = $FinishedHeader
@onready var countdown = $Countdownlabel
@onready var countdownTimer = $CountdownTimer
var countdownStrings :=["Go!","Get set...","On your mark...","Ready?"]
var countdownprogress := 3
func _ready() -> void:
	MenuMusic.play()
	QTEcontainer.visible = false
	countdown.text = countdownStrings[countdownprogress]
	countdown.visible=true
	countdownTimer.start()

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
	if linkedPlayer:
		if linkedPlayer.finished:
			finishedHeader.text = "Finished "+str(PlayerManager.finishOrder.find(linkedPlayer.playerNum)+1)+placementEndings[fmod(PlayerManager.finishOrder.find(linkedPlayer.playerNum)+1,10)]+"!"
			finishedHeader.visible=true
		var placement = PlayerManager.playerPlacements[linkedPlayer.playerNum]
		placementLabel.text=str(placement)+placementEndings[fmod(PlayerManager.playerPlacements[linkedPlayer.playerNum],10)]
		#placementLabel.text = str(PlayerManager.playerPlacements)
		#if multiplayer.is_server():
		#	print(str(PlayerManager.playerCheckDists))
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


func _on_countdown_timer_timeout() -> void:
	countdownprogress-=1
	if countdownprogress==-1:
		countdownTimer.stop()
		countdown.visible=false
	else:
		countdown.text = countdownStrings[countdownprogress]
	if countdownprogress==0:
		if linkedPlayer:
			linkedPlayer.started=true
