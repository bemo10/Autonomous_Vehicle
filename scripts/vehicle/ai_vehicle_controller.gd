extends Node

var geometryObjects = load("res://scripts/world builder/geometry_objects.gd")
var vehicle
var pathfindingObject
var aiVehicleControlEnabled = false
var aiVehicleControlTemporarilyDisabled = false
var recalculatePath = false
var currentPath = []
var currentNodeTarget = 0
var rightSideDrivingDistance


# Called when the node enters the scene tree for the first time.
func _ready():
	# Get parent vehicle
	vehicle = get_parent().get_node("Vehicle")
	
	# Get pathfinding object
	pathfindingObject = get_node("/root/Game/World/WorldBuilder/Pathfinding").pathfinding
	
	# How far to the right of the road should the vehicle drive
	rightSideDrivingDistance = geometryObjects.ROAD_THICKNESS * 0.5
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if aiVehicleControlEnabled and !aiVehicleControlTemporarilyDisabled:
		driveToTarget()
	
	if aiVehicleControlTemporarilyDisabled:
		recalculatePath = true
	else:
		if recalculatePath and !currentPath.empty():
			recalculatePath = false
			newPathFromTarget(currentPath[-1])
	
	
func driveToTarget():
	if currentNodeTarget < currentPath.size():
		# Steer towards target
		vehicle.maxSteering = 1
		vehicle.steeringLerp = 6
		var currentPosition = vehicle.transform.origin
		# Adjust target node position so that the vehicle drives on the right side of the road
		var targetNodePosition = pathfindingObject.astar.get_point_position(currentPath[currentNodeTarget])
		var previousTargetNodePosition = pathfindingObject.astar.get_point_position(currentPath[currentNodeTarget-1])
		var closestPointToRightSide = targetNodePosition
		if currentNodeTarget != 0:
			var pathVector = (targetNodePosition - previousTargetNodePosition).normalized()
			var rightSideDrivingTranslationVector = pathVector.rotated(Vector3(0,1,0), -90)
			targetNodePosition += rightSideDrivingTranslationVector * rightSideDrivingDistance
			previousTargetNodePosition += rightSideDrivingTranslationVector * rightSideDrivingDistance
			if (targetNodePosition - currentPosition).length() > 20:
				closestPointToRightSide = Geometry.get_closest_point_to_segment(currentPosition, previousTargetNodePosition, targetNodePosition)
				closestPointToRightSide += pathVector * 8
			else:
				closestPointToRightSide = targetNodePosition
		
		### Test: show target, previous target and closest point to the right side path
#		var test1 = get_node("/root/World/VehicleAiGizmos/test1")
#		var test2 = get_node("/root/World/VehicleAiGizmos/test2")
#		var test3 = get_node("/root/World/VehicleAiGizmos/test3")
#		test1.translation = previousTargetNodePosition
#		test2.translation = targetNodePosition
#		test3.translation = closestPointToRightSide
		###
		
		var targetVector = targetNodePosition - currentPosition
		var maxDistanceToClosestPoint = 2
		var distanceToClosestPoint = currentPosition.distance_to(closestPointToRightSide)
		if distanceToClosestPoint > maxDistanceToClosestPoint:
			targetVector = closestPointToRightSide - currentPosition
		var forwardVector = vehicle.linear_velocity.normalized()
		
		vehicle.steeringControl = forwardVector.cross(targetVector.normalized()).y
		if abs(vehicle.steeringControl) > 0.01 and vehicle.linear_velocity.length() > 20:
			vehicle.brakeControl = 3
		
		# Move to next target
		var distance = (targetNodePosition - currentPosition).length()
		var acceptableTargetDistance = 10
		if distance < acceptableTargetDistance:
			currentNodeTarget = currentNodeTarget+1
		
		# Accelerate forward
		vehicle.accelerationControl = 1
	else:
		currentPath = []
		if vehicle.linear_velocity.length() > 1:
			vehicle.brakeControl = 1
		else:
			aiVehicleControlEnabled = false


func newPathFromTarget(targetNode):
	var currentNode = pathfindingObject.astar.get_closest_point(vehicle.global_transform.origin)
	currentPath = pathfindingObject.astar.get_id_path (currentNode, targetNode)
	currentNodeTarget = 0
	
	# Skip first target node if it takes the vehicle in the opposite direction of path
	if currentPath.size() >= 2:
		var firstTargetVector = pathfindingObject.astar.get_point_position(currentPath[0]) - vehicle.transform.origin
		var secondTargetVector = pathfindingObject.astar.get_point_position(currentPath[1]) - vehicle.transform.origin
		var angleDifference = firstTargetVector.angle_to(secondTargetVector) * 180 / PI
		var maxAcceptableTurnAngle = 120
		if angleDifference > maxAcceptableTurnAngle:
			currentNodeTarget = 1


func getCurrentTargetPosition():
	return pathfindingObject.astar.get_point_position(currentPath[currentNodeTarget])

func getCurrentTargetPositionWithOffset():
	if currentNodeTarget == 0:
		return getCurrentTargetPosition()
	
	var targetNodePosition = pathfindingObject.astar.get_point_position(currentPath[currentNodeTarget])
	var previousTargetNodePosition = pathfindingObject.astar.get_point_position(currentPath[currentNodeTarget-1])
	var pathVector = (targetNodePosition - previousTargetNodePosition).normalized()
	var rightSideDrivingTranslationVector = pathVector.rotated(Vector3(0,1,0), -90)
	targetNodePosition += rightSideDrivingTranslationVector * rightSideDrivingDistance
	
	return targetNodePosition






