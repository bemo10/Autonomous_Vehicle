extends Spatial


var geometryObjects = load("res://scripts/world builder/geometry_objects.gd")
var playerVehicle
var playerVehicleAiController
var meshChild
var sideWalkSide
var sideWalkDistance
var pathfdingObject
var originalNode = null
var targetNode = null
var previousTargetNode = null
var normalSpeed = 6	# 10
var speed = normalSpeed
var entityTranslation
var enemyMode = false
var enemyPositionReachedCounterMax = 1.5
var enemyPositionReachedCounter = enemyPositionReachedCounterMax
var enemySpeed = 20
var enemyPosition
var enemyPreviousPosition = null
# Driver reaction variables
var interaction = load("res://objects/interaction.tscn")
var interactionContainer
var driverHasReacted = false
var timerHasStarted = false
var startingTime = 0
var endingTime = 0



# Animation
var animFreq = 0.008
var animAmp = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pathfdingObject = get_node("/root/Game/World/WorldBuilder/Pathfinding").pathfinding
	playerVehicle = get_node("/root/Game/World/PlayerVehicle/Vehicle")
	playerVehicleAiController = playerVehicle.get_parent().get_node("AiVehicleController")
	meshChild = get_node("Mesh")
	interactionContainer = get_node("/root/Game/World/Gui/Container/InteractionScrollContainer/InteractionContainer")
	
	sideWalkDistance = 1.6 + 0.3 * (randi() % 10) / 10
	
	# Entitiy translation for chunk system
	entityTranslation = translation
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Initialize
	if originalNode == null:
		targetNode = pathfdingObject.astar.get_closest_point(translation)
		previousTargetNode = pathfdingObject.astar.get_point_connections(targetNode)[0]
		originalNode = targetNode
		var targetPosition = pathfdingObject.astar.get_point_position(targetNode)
		var previousTargetPosition = pathfdingObject.astar.get_point_position(previousTargetNode)
		var pathSegmentVector = (targetPosition - previousTargetPosition).normalized()
		var sideWalkTranslationVector = pathSegmentVector.rotated(Vector3(0,1,0), 90 * sideWalkSide)
		var sideWalkDistance = geometryObjects.ROAD_THICKNESS * 1.6
		translate(sideWalkTranslationVector * sideWalkDistance)
		
	
	# Get target Position
	var targetPosition = pathfdingObject.astar.get_point_position(targetNode)
	var previousTargetPosition = pathfdingObject.astar.get_point_position(previousTargetNode)
	
	var pathSegmentVector = (targetPosition - previousTargetPosition).normalized()
	var sideWalkTranslationVector = pathSegmentVector.rotated(Vector3(0,1,0), 90 * sideWalkSide)
	var sideWalkDistance = geometryObjects.ROAD_THICKNESS * 1.6
	
	targetPosition = targetPosition + sideWalkTranslationVector * sideWalkDistance
	speed = normalSpeed
	
	# Driver reaction
	if driverHasReacted == false and timerHasStarted == true:
		if enemyMode == true or enemyPositionReachedCounter > 0:
			if playerVehicleAiController.aiVehicleControlTemporarilyDisabled == true:
				driverHasReacted = true
				endingTime = Time.get_ticks_msec()
	
	
	# Enemy mode (try to get in front of player to make them lose)
	if enemyPositionReachedCounter > 0:
		enemyMode = false
		enemyPositionReachedCounter -= 1 * delta
		speed = 0
	else:
		# Driver reaction
		if timerHasStarted == true and driverHasReacted == true and enemyMode == false:
			timerHasStarted = false
			driverHasReacted = false
			var reactionTime = float(endingTime - startingTime) / 1000
			if reactionTime > 0:
				var interactionInstance = interaction.instance()
				interactionInstance.accidentPrevented = true
				interactionInstance.reactionSpeed = reactionTime
				interactionContainer.add_child(interactionInstance)
	
	
	if enemyMode == true:
		speed = enemySpeed
		targetPosition = enemyPosition
		if enemyPreviousPosition == null:
			enemyPreviousPosition = translation
		# Driver reaction
		if timerHasStarted == false:
			timerHasStarted = true
			startingTime = Time.get_ticks_msec()
	else:
		if enemyPreviousPosition != null:
			targetPosition = enemyPreviousPosition
		
	
	
	
	
	# Get vector to target Node
	var VectorToTarget = translation.direction_to(targetPosition)
	
	# Move
	move(speed * delta, VectorToTarget)
	
	# Get new Target node
	if translation.distance_to(targetPosition) <= speed * delta:
		# enemy mode
		if enemyMode == true:
			enemyMode = false
			enemyPositionReachedCounter = enemyPositionReachedCounterMax
		else:
			if enemyPreviousPosition != null:
				enemyPreviousPosition = null
		
		#
		var previousVector = targetPosition - previousTargetPosition
		
		previousTargetNode = targetNode
		if targetNode == originalNode:
			var connections = pathfdingObject.astar.get_point_connections(originalNode)
			targetNode = connections[randi() % connections.size()]
		else:
			targetNode = originalNode
		
		# Change sidewalk side when turning more than 90 degrees
		targetPosition = pathfdingObject.astar.get_point_position(targetNode)
		previousTargetPosition = pathfdingObject.astar.get_point_position(previousTargetNode)
		var newVector = targetPosition - previousTargetPosition
		
		if previousVector.dot(newVector) < 0:
			sideWalkSide = -sideWalkSide
	
	# Rotation
	meshChild.look_at(targetPosition, Vector3.UP)
	
	if enemyPositionReachedCounter > 0:
		meshChild.look_at(playerVehicle.translation, Vector3.UP)
	
	# Simple animation
	meshChild.get_child(2).translation.y = abs( cos(Time.get_ticks_msec() * animFreq) * animAmp )
	
	
	### GOES LAST: Entitiy translation for chunk system
	entityTranslation = translation
	



func move(speed, direction):
	# Movement
	translate(direction.normalized() * speed)
	
	

func activate():
	pass
	
	
func deactivate():
	pass
	
	
