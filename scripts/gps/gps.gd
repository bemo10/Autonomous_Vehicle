extends Node


var gpsEnabled = false
var pathfindingObject
var buildingsLayer
var pathwaysLayer
var gpsCamera
var crosshair
var playerIcon
var destinationIcon
var vehicle
var vehicleAi
var vehicleManualControl
var destinationPosition = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pathfindingObject = get_node("/root/Game/World/WorldBuilder/Pathfinding").pathfinding
	buildingsLayer = get_node("/root/Game/World/WorldBuilder/GeometryBuilder/BuildingsLayer")
	pathwaysLayer = get_node("/root/Game/World/WorldBuilder/GeometryBuilder/PathwaysLayer")
	gpsCamera = self.get_node("Camera")
	vehicle = get_node("/root/Game/World/PlayerVehicle/Vehicle")
	vehicleAi = vehicle.get_parent().get_node("AiVehicleController")
	vehicleManualControl = vehicle.get_parent().get_node("ManualVehicleController")
	crosshair = get_node("/root/Game/World/Gui/GpsGui/Container/Crosshair")
	playerIcon = get_node("/root/Game/World/Gui/GpsGui/PlayerIcon")
	destinationIcon = get_node("/root/Game/World/Gui/GpsGui/DestinationIcon")
	
	disableGps()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Enable or disable GPS
	if Input.is_action_just_pressed("gps_toggle"):
		if gpsEnabled:
			disableGps()
		else:
			enableGps()
	
	# Do stuff when gps is enabled
	if gpsEnabled:
		# Select path
		selectDestination()
		
		# Draw player and destination icons
		playerIcon.position = gpsCamera.unproject_position(vehicle.translation)
		if destinationPosition != null:
			destinationIcon.position = gpsCamera.unproject_position(destinationPosition)
			if vehicleAi.currentPath.empty():
				destinationPosition = null
		else:
			# Out of view position
			destinationIcon.position = Vector2(-1000, -1000)
		
	
	
	

func enableGps():
	gpsEnabled = true
	
	# Make icons visible
	crosshair.visible = true
	playerIcon.visible = true
	destinationIcon.visible = true
	
	# Change buildings scale and pathways height
	buildingsLayer.scale = Vector3(1, 0.2, 1)
	pathwaysLayer.translation = Vector3(0, 10, 0)
	
	# Make gps camera current
	gpsCamera.make_current()
	
	# Set camera position to vehicle position
	var cameraPosition = gpsCamera.global_translation
	cameraPosition.x = vehicle.global_translation.x
	cameraPosition.z = vehicle.global_translation.z
	gpsCamera.global_translation = cameraPosition
	
	# Disable manual vehicle control
	vehicleManualControl.manualVehicleControlEnabled = false
	
	# Disable vehicle first person camera
	vehicle.get_node("CameraFirstPerson").freelook = false
	

func disableGps():
	gpsEnabled = false
	
	# Make icons invisible
	crosshair.visible = false
	playerIcon.visible = false
	destinationIcon.visible = false
	
	# Reset buildings scale and pathways height
	buildingsLayer.scale = Vector3(1, 1, 1)
	pathwaysLayer.translation = Vector3(0, 0, 0)
	
	# Make gps camera not current
	gpsCamera.clear_current()
	
	# Enable manual vehicle control
	vehicleManualControl.manualVehicleControlEnabled = true
	
	# Enable vehicle first person camera
	vehicle.get_node("CameraFirstPerson").freelook = true
	
	

func selectDestination():
	if Input.is_action_just_pressed("mouse_select"):
		vehicleAi.aiVehicleControlEnabled = true
		var targetPosition = gpsCamera.global_translation
		targetPosition.y = 0
		self.destinationPosition = targetPosition
		var targetNode = pathfindingObject.astar.get_closest_point(targetPosition)
		vehicleAi.newPathFromTarget(targetNode)
		disableGps()
	if Input.is_action_just_pressed("mouse_cancel"):
		vehicleAi.aiVehicleControlEnabled = false
		self.destinationPosition = null
		disableGps()
