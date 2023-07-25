extends Node

const ROAD_THICKNESS = 6
const SIDEWALK_THICKNESS = 2.5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


class Zone:
	var id = null
	var nodes = []
	var type = null
	var levels = 1
	
	func _init(zoneId, zoneNodes, zoneType, zoneLevels):
		id = zoneId
		nodes = zoneNodes
		type = zoneType
		levels = zoneLevels
	


class Pathway:
	var id = null
	var nodes = []
	var type = null
	var thickness = 1
	var color = null
	var isDrivable = false
	
	func _init(wayId, wayNodes, wayType):
		id = wayId
		nodes = wayNodes
		type = wayType
		isDrivable = checkIsDrivable()
		setPathThickness()
	
	func checkIsDrivable():
		var drivablePathways = ["motorway", "trunk", "primary", "secondary", "tertiary", "unclassified", 
		"residential", "motorway_link", "trunk_link", "primary_link", "secondary_link", "tertiary_link", 
		"living_street", "service", "track", "escape", "raceway", "road"]
		if drivablePathways.has(type):
			return true
		return false
	
	func setPathThickness():
		if isDrivable:
			thickness = ROAD_THICKNESS
		else:
			thickness = SIDEWALK_THICKNESS
	
	
	


