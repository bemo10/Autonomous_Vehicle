extends Node


var pathfindingObject
var vehicleAi
var vehicle
var entityTranslation

# Called when the node enters the scene tree for the first time.
func _ready():
	pathfindingObject = get_node("/root/Game/World/WorldBuilder/Pathfinding").pathfinding
	vehicle = get_node("Vehicle")
	
	# Enable ai control
	vehicleAi = get_node("AiVehicleController")
	vehicleAi.aiVehicleControlEnabled = true
	
	# Get vehicle translation (needed for chunk system)
	entityTranslation = vehicle.translation
	
	# Do all vehicle initialization stuff here. That way it's called when vehicle is duplicated
	initializeVehicle()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Calculate new path every time we reach a destination
	npcVehiclePath()
	
	# Get vehicle translation (needed for chunk system)
	entityTranslation = vehicle.translation
	
	# Weird VehicleBody bug bandaid fix
	if entityTranslation.y < -0.05:
		var newVehicle = vehicle.duplicate()
		vehicle.queue_free()
		add_child(newVehicle)
		vehicle = newVehicle
		vehicleAi.vehicle = newVehicle
		initializeVehicle()
	
	


func initializeVehicle():
	# Remove buildings from collision mask
	vehicle.set_collision_mask_bit(2, false)
	
	# Change max speed for npc vehicles
	vehicle.maxRpm = 1200		# 1400
	vehicle.maxTorque = 450		# 600



func npcVehiclePath():
	if vehicleAi.currentPath.empty():
		var nGraphPoints = pathfindingObject.astar.get_point_count()
		var targetNode = randi() % nGraphPoints
		vehicleAi.newPathFromTarget(targetNode)


func activate():
	#get_node("Vehicle").mode = RigidBody.MODE_RIGID
	vehicle.get_node("Car").visible = true
	for child in get_children():
		child.set_process(true)
		child.set_physics_process(true)
	
	


func deactivate():
	#get_node("Vehicle").mode = RigidBody.MODE_STATIC
	vehicle.get_node("Car").visible = false
	for child in get_children():
		child.set_process(false)
		child.set_physics_process(false)
	
	
