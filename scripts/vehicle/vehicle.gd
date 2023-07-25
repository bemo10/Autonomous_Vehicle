extends VehicleBody


var maxRpm = 1000
var maxTorque = 400
var breakForce = 5

# Control variables used by AI and manual driving scripts to control this vehicle
var accelerationControl = 0
var steeringControl = 0
var brakeControl = 0

var maxSteering = 0.3
var steeringLerp = 2

func _ready():
	var pathfindingObject = get_node("/root/Game/World/WorldBuilder/Pathfinding").pathfinding
	var currentNode = pathfindingObject.astar.get_closest_point(self.transform.origin)
	self.translate(pathfindingObject.astar.get_point_position(currentNode))

func _physics_process(delta):
	# Steering
	if steeringControl != 0:
		steering = lerp(steering, steeringControl * maxSteering, steeringLerp * delta)
	else:
		steering = lerp(steering, 0, 5 * delta)
	
	# Acceleration
	var acceleration = accelerationControl
	var rpm
	rpm = abs($BackLeftWheel.get_rpm())
	$BackLeftWheel.engine_force = acceleration * maxTorque * (1 - rpm / maxRpm)
	rpm = abs($BackRightWheel.get_rpm())
	$BackRightWheel.engine_force = acceleration * maxTorque * (1 - rpm / maxRpm)
	
	# brake
	brake = breakForce * brakeControl
	
	if linear_velocity.length() < 1 and brake > 0:
		brake = 0
	
	# Reset control variables
	accelerationControl = 0
	steeringControl = 0
	brakeControl = 0

