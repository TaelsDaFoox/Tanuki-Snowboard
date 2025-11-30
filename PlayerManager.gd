extends Node
var playerDevices: Array
var playerChars = [0,0,0,0]
#func get_unclaimed_devices():
#	var devices = Input.get_connected_joypads()
#	return devices.filter(func(device): return !playerDevices.has(device))
