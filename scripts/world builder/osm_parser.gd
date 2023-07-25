extends Node

var osmFile = "res://osm/map.osm"
var geometryObjs = load("res://scripts/world builder/geometry_objects.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#print("starting parse funcion")
	#var data = parseOsm()
	#test
	#print("lat: ", data[0][6192695057][0], "  lon: ", data[0][6192695057][1])
	#print(data[1][662891364])
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func parseOsm():
	var parser = XMLParser.new()
	var err = parser.open(osmFile)
	if err != OK:
		print("Error opening osm file: ", err)
	else:
		print("osm file opened successfully!")
	
	var nodes = {}
	var buildings = {}
	var buildingLevels = 1
	var pathways = {}
	var pathwayType = ""
	
	while parser.read() == 0:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var nodeName = parser.get_node_name()
			if nodeName == "node":
				var nodeId = int(parser.get_named_attribute_value ("id"))
				var nodeLongitude = float(parser.get_named_attribute_value ("lon"))
				var nodeLatitude = float(parser.get_named_attribute_value ("lat"))
				nodes[nodeId] = [nodeLongitude, nodeLatitude]
			elif nodeName == "way":
				var nodeId = int(parser.get_named_attribute_value ("id"))
				var wayNodes = []
				while(parser.get_node_type() != XMLParser.NODE_ELEMENT_END or parser.get_node_name() != "way"):
					var isBuilding = false
					var isPathway = false
					parser.read()
					if parser.get_node_type() != XMLParser.NODE_TEXT:
						if parser.get_node_name() == "nd":
							wayNodes.append( int(parser.get_named_attribute_value("ref")) )
						elif parser.get_node_name() == "tag":
							# Building way
							if parser.get_named_attribute_value_safe("k") == "building":
								isBuilding = true
							if parser.get_named_attribute_value_safe("k") == "building:levels":
								buildingLevels = int(parser.get_named_attribute_value_safe("v"))
							# Path way
							if parser.get_named_attribute_value_safe("k") == "highway":
								isPathway = true
								pathwayType = parser.get_named_attribute_value_safe("v")
					if isBuilding:
						var building = geometryObjs.Zone.new(nodeId, wayNodes, "building", buildingLevels)
						buildings[nodeId] = building
					if isPathway:
						var pathway = geometryObjs.Pathway.new(nodeId, wayNodes, pathwayType)
						pathways[nodeId] = pathway
	# center map to world origin
	nodes = coords2xy(nodes)
	nodes = offsetCoords(nodes)
	
	print("parse done!")
	return [nodes, buildings, pathways]



#func offsetCoords(coords):
#	var myCoords = coords
#	var coordKeys = myCoords.keys()
#	var minX = myCoords[coordKeys[0]][0]
#	var minY = myCoords[coordKeys[0]][1]
#	var maxX = myCoords[coordKeys[0]][0]
#	var maxY = myCoords[coordKeys[0]][1]
#
#	for key in coordKeys:
#		if myCoords[key][0] < minX:
#			minX = myCoords[key][0]
#		if myCoords[key][1] < minY:
#			minY = myCoords[key][1]
#		if myCoords[key][0] > maxX:
#			maxX = myCoords[key][0]
#		if myCoords[key][1] > maxY:
#			maxY = myCoords[key][1]
#	print(minX, " ", minY, " ", maxX, " ", maxY)
#	print ((minX + maxX)/2)
#	print ((minY + maxY)/2)
#	for key in coordKeys:
#		myCoords[key][0] = myCoords[key][0] - (minX + maxX)/2
#		myCoords[key][1] = myCoords[key][1] - (minY + maxY)/2
#	return myCoords


func offsetCoords(coords):
	var myCoords = coords
	var coordKeys = myCoords.keys()
	var keyCount = coordKeys.size()
	var xOffset = myCoords[coordKeys[keyCount/2]][0]
	var yOffset = myCoords[coordKeys[keyCount/2]][1]
	for key in coordKeys:
		myCoords[key][0] = myCoords[key][0] - xOffset
		myCoords[key][1] = myCoords[key][1] - yOffset
	return myCoords


func coords2xy(coords):
	var myCoords = coords
	var multiplier = 500000
	for key in coords.keys():
		myCoords[key][0] = myCoords[key][0] * multiplier
		myCoords[key][1] = myCoords[key][1] * multiplier
	return myCoords





