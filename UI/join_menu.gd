extends Control
@onready var consoleLabel = $ConsoleLabel
@onready var cursors = [$CursorP1,$CursorP2,$CursorP3,$CursorP4]
var playerChars = [0,0,0,0]
@onready var CSSrects = [$PlayerRect1,$PlayerRect2,$PlayerRect3,$PlayerRect4]
func _input(event: InputEvent) -> void:
	for i in PlayerManager.playerDevices.size():
		if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[i],"Right"):
			playerChars[i]+=1
		if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[i],"Left"):
			playerChars[i]-=1
		if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[i],"Down"):
			playerChars[i]+=4
		if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[i],"Up"):
			playerChars[i]-=4
		playerChars[i] = fmod(playerChars[i],$CharacterIcons.get_child_count())
			
	if event.is_action_pressed("Crouch") and event is InputEventKey:
		if not PlayerManager.playerDevices.has(-1):
			PlayerManager.playerDevices.append(-1)
		else:
			print("kb already added!!")
func _process(delta: float) -> void:
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
		cursors[i].global_position = cursors[i].global_position.lerp($CharacterIcons.get_child(playerChars[i]).global_position,delta*20)
	

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Courses/Course1.tscn")
