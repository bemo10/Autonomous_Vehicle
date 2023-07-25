extends Area


var playerVehicle
var vehicle
var aiController
var enemyTarget
var enemyCooldown = 0
var enemyCooldownMax = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	vehicle = get_parent()
	playerVehicle = vehicle.get_parent()
	aiController = playerVehicle.get_node("AiVehicleController")
	enemyTarget = vehicle.get_node("EnemyTarget")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !aiController.currentPath.empty() and aiController.aiVehicleControlEnabled and !aiController.aiVehicleControlTemporarilyDisabled:
		# Get overlapping pedestrians
		var overlapPedestrians = get_overlapping_areas()
		
		# Turn pedestrians enemy mode ON
		var enemyChance = 150
		if enemyCooldown <= 0:
			for pedestrianArea in overlapPedestrians:
				if randi() % enemyChance == 1:
					var pedestrian = pedestrianArea.get_parent()
					pedestrian.enemyMode = true
					var pedestrianTranslation = pedestrian.translation
					var vehicleTranslation = vehicle.translation
					var targetNodeTranslation = aiController.getCurrentTargetPositionWithOffset()
					pedestrian.enemyPosition = Geometry.get_closest_point_to_segment_uncapped(pedestrianTranslation, vehicleTranslation, targetNodeTranslation)
					enemyCooldown = enemyCooldownMax
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemyCooldown > 0:
		enemyCooldown -= 1 * delta
	else:
		enemyCooldown = 0
	
	
	
	
