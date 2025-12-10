extends Node
@onready var music = $Music
var musicCredit:='♪stuck - John "Joy" Tay'
var CharSelectStart := "res://Audio/Music/02 Start Your Engines.mp3"
var CharSelectLoop := "res://Audio/Music/RMenuLoop.mp3"
var playing:=false
func play():
	if not playing:
		playing=true
		musicCredit='♪stuck - John "Joy" Tay'
		music.play(0.0)
func stop():
	music.stop()
	playing=false
func CharSelect():
	musicCredit = "♪Daytona USA (Arcade) - Start Your Engines - Takenobu Mitsuyoshi"
	music.stream = load(CharSelectStart)
	music.play()
func _on_music_finished() -> void:
	musicCredit = "♪Sonic R - Options Screen - Richard Jacques"
	music.stream = load(CharSelectLoop)
	music.play()
