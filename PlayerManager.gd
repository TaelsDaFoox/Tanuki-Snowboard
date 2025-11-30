extends Node
var playerDevices: Array
var playerChars = [0,0,0,0]
var charModels = [load("res://Models/Characters/Jolt.tscn"),load("res://Models/Characters/Blolt.tscn"),load("res://Models/Characters/Tammy.tscn"),load("res://Models/Characters/Sapph.tscn")]
#func get_unclaimed_devices():
#	var devices = Input.get_connected_joypads()
#	return devices.filter(func(device): return !playerDevices.has(device))
