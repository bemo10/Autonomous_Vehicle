extends Node


var pedestrianRes = preload('res://objects/pedestrian.tscn')
var geometryObjects = load("res://scripts/world builder/geometry_objects.gd")
var pathfindingObject
var chunkSystem
var nPedestrians = 10000   #10000

# Called when the node enters the scene tree for the first time.
func _ready():
	pathfindingObject = get_node("/root/Game/World/WorldBuilder/Pathfinding").pathfinding
	chunkSystem = get_node("ChunkSystem")


func _process(delta):
	if nPedestrians > 0:
		# Create pedestrians
		var pedestrianInstance = pedestrianRes.instance()
		#add_child(pedestrianInstance)
		var sideWalkSide = -1 + 2 * (randi() % 2)
		pedestrianInstance.sideWalkSide = sideWalkSide
		chunkSystem.add_child(pedestrianInstance)
		chunkSystem.initializeEntity(pedestrianInstance)
		
		# Choose spawn location
#		var nGraphPoints = pathfindingObject.astar.get_point_count()
#		var node1 = randi() % nGraphPoints
#		var connections = pathfindingObject.astar.get_point_connections(node1)
#		var node2 = connections[randi() % connections.size()]
#		node1 = pathfindingObject.astar.get_point_position(node1)
#		node2 = pathfindingObject.astar.get_point_position(node2)
#
#		var pathSegmentVector = (node1 - node2).normalized()
#		var sideWalkTranslationVector = pathSegmentVector.rotated(Vector3(0,1,0), 90 * sideWalkSide)
#		var sideWalkDistance = geometryObjects.ROAD_THICKNESS * 1.6
#
#		# Get point between 2 nodes based on percentage
#		var distance = node1.distance_to(node2) * (randi() % 10) / 10
#		var diffrence = node2 - node1
#		var spawnPointTranslation = diffrence.normalized() * distance
#		var spawnPoint = node1 + spawnPointTranslation
#
#		pedestrianInstance.translation = spawnPoint + sideWalkTranslationVector * sideWalkDistance
		
		
		var nGraphPoints = pathfindingObject.astar.get_point_count()
		var spawnPoint = pathfindingObject.astar.get_point_position(nPedestrians % nGraphPoints)
		pedestrianInstance.translation = spawnPoint
		
		# Decrement
		nPedestrians -= 1


