extends Node
@onready var music = $Music
var playing:=false
func play():
	if not playing:
		playing=true
		music.play(0.0)
func stop():
	music.stop()
	playing=false
