extends Control
@onready var cursor = $CursorP1
@onready var courseNameLabel = $CourseName
var courseNames:=["Glacial Slopes","Castle Siege (unfinished)"]
@onready var hostChoosingLabel = $HostChoosing
func _process(delta: float) -> void:
	musicCredit.text=MenuMusic.musicCredit
	cursor.global_position = cursor.global_position.lerp($CourseIcons.get_child(PlayerManager.selectedCourse).global_position,delta*20)
	hostChoosingLabel.visible = PlayerManager.playerUIDs and not multiplayer.is_server()
@onready var musicCredit = $MusicCredit
func _input(event: InputEvent) -> void:
	if not (PlayerManager.playerUIDs and not multiplayer.is_server()):
		if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[0],"Right"):
			PlayerManager.selectedCourse+=1
		if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[0],"Left"):
			PlayerManager.selectedCourse-=1
		if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[0],"Down"):
			PlayerManager.selectedCourse+=4
		if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[0],"Up"):
			PlayerManager.selectedCourse-=4
	PlayerManager.selectedCourse = fmod(PlayerManager.selectedCourse,$CourseIcons.get_child_count())
	courseNameLabel.text=courseNames[PlayerManager.selectedCourse]
	if multiplayer.is_server():
			setCourse.rpc(PlayerManager.selectedCourse)
		#$CharacterIcons.get_child_count()
	if PlayerManager.selectedCourse<0:
		PlayerManager.selectedCourse=$CourseIcons.get_child_count()-1
	if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[0],"Crouch") and (not (PlayerManager.playerUIDs and not multiplayer.is_server())):
		if multiplayer.is_server():
			startMatch.rpc(PlayerManager.selectedCourse)
		get_tree().change_scene_to_file(PlayerManager.coursePaths[PlayerManager.selectedCourse])
@rpc("authority", "call_remote", "reliable", 0)
func startMatch(map:int):
	get_tree().change_scene_to_file(PlayerManager.coursePaths[map])
@rpc("authority", "call_remote", "unreliable_ordered", 0)
func setCourse(map:int):
	PlayerManager.selectedCourse=map
	courseNameLabel.text=courseNames[PlayerManager.selectedCourse]
