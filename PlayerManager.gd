extends Node
var playerDevices: Array
var playerChars = [0,0,0,0]
var charModels = [load("res://Models/jolt snowboard.glb"),load("res://Models/Characters/Blolt.tscn"),load("res://Models/Characters/Tammy.tscn"),load("res://Models/Re-Sapph Snowboard.glb"),load("res://Models/Characters/Pi.tscn")]
var charNames = ["Jolt","Blolt","Tammy","Sapphire","Pi"]
var playerCheckDists := [10000.0,10000.0,10000.0,10000.0]
var playerCheckpoints := [0,0,0,0]
var playerPlacements := [1,2,3,4]

func _process(delta: float) -> void:
	if not playerPlacements.size() == playerDevices.size():
		playerPlacements.clear()
		playerCheckDists.clear()
		for i in playerDevices.size():
			playerPlacements.append(1)
			playerCheckDists.append(0)
	var sortedCheckDists = playerCheckDists.duplicate()
	sortedCheckDists.sort()
	sortedCheckDists.reverse()
	for i in playerPlacements.size():
		playerPlacements[i] = sortedCheckDists.find(playerCheckDists[i])+1
	#print(playerCheckDists)
	print(playerPlacements)
func logDist(plr:int,val:float):
	playerCheckDists[plr]=val

#I was looking into mod support and while it's definitely possible to do,
#I think it's out of the scope of the Siege build

#func _ready() -> void:
	#var modPath = OS.get_executable_path().get_base_dir() + "/modCharacters"
	#var modDir := DirAccess.open(modPath)
	#charModels.append(load(modload))
#func get_unclaimed_devices():
#	var devices = Input.get_connected_joypads()
#	return devices.filter(func(device): return !playerDevices.has(device))
