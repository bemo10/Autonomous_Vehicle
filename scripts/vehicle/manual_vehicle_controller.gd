extends Node


var vehicle
var aiVehicle
var manualVehicleControlEnabled = true
var aiDisableTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get parent vehicle
	vehicle = get_parent().get_node("Vehicle")
	# Get vehicle AI controller
	aiVehicle = get_parent().get_node("AiVehicleController")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Manual control
	if manualVehicleControlEnabled:
		# Steering
		vehicle.maxSteering = 0.3
		vehicle.steeringLerp = 2
		vehicle.steeringControl = Input.get_axis("right", "left")
		
		# Acceleration
		vehicle.accelerationControl = Input.get_axis("backward", "forward")
		
		# brake
		if Input.is_action_pressed("brake"):
			vehicle.brakeControl = 2	# 1
		
		# Disable ai control when manually controlling
		if aiDisableTimer > 0:
			aiDisableTimer -= delta
			aiVehicle.aiVehicleControlTemporarilyDisabled = true
		else:
			aiVehicle.aiVehicleControlTemporarilyDisabled = false
		
		var aiDisableTime = 1
		if Input.get_axis("right", "left") or Input.get_axis("backward", "forward") or Input.is_action_pressed("brake"):
			aiDisableTimer = aiDisableTime
