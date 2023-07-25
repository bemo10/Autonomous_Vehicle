extends Node


var npcVehicleRes = preload('res://objects/npc_vehicle.tscn')
var pathfindingObject
var chunkSystem
var nVehicles = 3000	#2000

# Called when the node enters the scene tree for the first time.
func _ready():
	pathfindingObject = get_node("/root/Game/World/WorldBuilder/Pathfinding").pathfinding
	chunkSystem = get_node("ChunkSystem")
	
#	# Create NPC vehicles
#	var npcVehicles = []
#	for n in range(10):
#		var npcVehicleInstance = npcVehicleRes.instance()
#		chunkSystem.add_child(npcVehicleInstance)
#		npcVehicles.append(npcVehicleInstance)
#		chunkSystem.initializeEntity(npcVehicleInstance)
#
#	# Choose spawn location
#	var nGraphPoints = pathfindingObject.astar.get_point_count()
#	for npcVehicle in npcVehicles:
#		var vehicle = npcVehicle.get_node("Vehicle")
#		var spawnNode = randi() % nGraphPoints
#		vehicle.translation = pathfindingObject.astar.get_point_position(spawnNode)
#		#vehicle.translation = Vector3(0, 0, 0)
	
	# Initialize chunk system
	#chunkSystem.initialize()


func _process(delta):
	if nVehicles > 0:
		# Create NPC vehicles
		var npcVehicleInstance = npcVehicleRes.instance()
		chunkSystem.add_child(npcVehicleInstance)
		chunkSystem.initializeEntity(npcVehicleInstance)
		
		# Choose spawn location
		var nGraphPoints = pathfindingObject.astar.get_point_count()
		var vehicle = npcVehicleInstance.get_node("Vehicle")
		var spawnNode = randi() % nGraphPoints
		vehicle.translation = pathfindingObject.astar.get_point_position(spawnNode)
		
		# Decrement
		nVehicles -= 1
		
	
	
	




