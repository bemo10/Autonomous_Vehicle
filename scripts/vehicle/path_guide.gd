extends Spatial

var pathfindingObject
var arrow
var vehicleAi
var vehicle
var arrowDirection = Vector3(0, 0, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pathfindingObject = get_node("/root/Game/World/WorldBuilder/Pathfinding").pathfinding
	arrow = self.get_node("Arrow")
	vehicleAi = self.get_parent()
	vehicle = vehicleAi.get_parent().get_node("Vehicle")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if vehicleAi.aiVehicleControlEnabled and !vehicleAi.currentPath.empty():
		self.visible = true
		var distanceFromVehicleCenter = 2
		var height = 3
		
		var arrowPosition = vehicle.global_translation + vehicle.transform.basis.z * distanceFromVehicleCenter
		arrowPosition.y = height
		var targetSkips = 2
		var targetIndex = min(findClosestNodeIndex(vehicleAi.currentPath)+targetSkips, vehicleAi.currentPath.size()-1)
		var targetPosition = pathfindingObject.astar.get_point_position(vehicleAi.currentPath[targetIndex])
		targetPosition.y = height
		
		self.global_translation = arrowPosition
		self.look_at(targetPosition, Vector3.UP)
	else:
		self.visible = false


func findClosestNodeIndex(path):
	var closestIndex = 0
	var closestDistance = 999999999
	for i in range(path.size()):
		var distance =  vehicle.translation.distance_to(pathfindingObject.astar.get_point_position(path[i]))
		if distance < closestDistance:
			closestIndex = i
			closestDistance = distance
	return closestIndex
