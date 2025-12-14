extends Control
var selectedCourse = 0
@onready var cursor = $CursorP1
var coursePaths :=["res://Scenes/Courses/Course1.tscn","res://Scenes/Courses/Course2.tscn"]
func _process(delta: float) -> void:
	musicCredit.text=MenuMusic.musicCredit
	cursor.global_position = cursor.global_position.lerp($CourseIcons.get_child(selectedCourse).global_position,delta*20)
@onready var musicCredit = $MusicCredit
func _input(event: InputEvent) -> void:
	if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[0],"Right"):
		selectedCourse+=1
	if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[0],"Left"):
		selectedCourse-=1
	if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[0],"Down"):
		selectedCourse+=4
	if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[0],"Up"):
		selectedCourse-=4
	selectedCourse = fmod(selectedCourse,$CourseIcons.get_child_count())
		#$CharacterIcons.get_child_count()
	if selectedCourse<0:
		selectedCourse=$CourseIcons.get_child_count()-1
	if MultiplayerInput.is_action_just_pressed(PlayerManager.playerDevices[0],"Crouch"):
		if multiplayer.is_server():
			startMatch.rpc()
		get_tree().change_scene_to_file(coursePaths[selectedCourse])
@rpc("authority", "call_remote", "reliable", 0)
func startMatch():
	get_tree().change_scene_to_file(coursePaths[selectedCourse])
