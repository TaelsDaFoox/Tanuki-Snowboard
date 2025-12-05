extends Control
@onready var consoleLabel = $ConsoleLabel
@onready var cursors = [$CursorP1,$CursorP2,$CursorP3,$CursorP4]
@onready var CSSrects = [$PlayerRect1,$PlayerRect2,$PlayerRect3,$PlayerRect4]
@onready var joinPrompts = [$JoinPrompt1,$JoinPrompt2,$JoinPrompt3,$JoinPrompt4]
@onready var charNameLabels = [$CharName1,$CharName2,$CharName3,$CharName4]
var joinPromptVisible = true
func _input(event: InputEvent) -> void:
	for i in PlayerManager.playerDevices.size():
		if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[i],"Right"):
			PlayerManager.playerChars[i]+=1
		if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[i],"Left"):
			PlayerManager.playerChars[i]-=1
		if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[i],"Down"):
			PlayerManager.playerChars[i]+=4
		if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[i],"Up"):
			PlayerManager.playerChars[i]-=4
		PlayerManager.playerChars[i] = fmod(PlayerManager.playerChars[i],PlayerManager.charNames.size())
		#$CharacterIcons.get_child_count()
		if PlayerManager.playerChars[i]<0:
			PlayerManager.playerChars[i]=$CharacterIcons.get_child_count()-1
	if event.is_action_pressed("Crouch") and event is InputEventKey:
		if not PlayerManager.playerDevices.has(-1):
			PlayerManager.playerDevices.append(-1)
		else:
			print("kb already added!!")
func _process(delta: float) -> void:
	for i in charNameLabels.size():
		if PlayerManager.playerChars[i]<PlayerManager.charNames.size():
			charNameLabels[i].text = PlayerManager.charNames[PlayerManager.playerChars[i]]
		charNameLabels[i].visible=i<PlayerManager.playerDevices.size()
	for i in joinPrompts.size():
		if i == PlayerManager.playerDevices.size():
			joinPrompts[i].visible=joinPromptVisible
		else:
			joinPrompts[i].visible=false
	consoleLabel.text = "devices: \n"+str(PlayerManager.playerDevices)
	for i in Input.get_connected_joypads():
		if MultiplayerInput.is_action_just_pressed(i, "Crouch"):
			print("some input, somewhere")
			if not PlayerManager.playerDevices.has(i):
				PlayerManager.playerDevices.append(i)
				print("append gamepad " + str(i))
			else:
				print("device already added!!")
	for i in cursors.size():
		cursors[i].visible = i<PlayerManager.playerDevices.size()
		CSSrects[i].visible = i<PlayerManager.playerDevices.size()
		cursors[i].global_position = cursors[i].global_position.lerp($CharacterIcons.get_child(PlayerManager.playerChars[i]).global_position,delta*20)
	

func _on_button_pressed() -> void:
	if multiplayer.is_server():
		startMatch.rpc()
	get_tree().change_scene_to_file("res://Scenes/Courses/Course1.tscn")


func _on_flash_timer_timeout() -> void:
	joinPromptVisible=not joinPromptVisible


func _on_button_focus_entered() -> void:
	$Button.release_focus()

@rpc("authority", "call_remote", "reliable", 0)
func startMatch():
	get_tree().change_scene_to_file("res://Scenes/Courses/Course1.tscn")
