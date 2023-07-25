extends Area


var vehicle
var playerVehicleDetected = false
var npcDetected = false


# Called when the node enters the scene tree for the first time.
func _ready():
	vehicle = get_parent()
	
	


func _physics_process(delta):
	# Reset detection variables
	playerVehicleDetected = false
	npcDetected = false
	
	# Detect entities (player and npc vehicles and pedestrians)
	var overlapEntities = get_overlapping_areas()
	
	for entity in overlapEntities:
		if entity.get_collision_layer_bit(7) == true:
			playerVehicleDetected = true
		if entity.get_collision_layer_bit(6) == true:
			npcDetected = true
		
#	if npcDetected == true:
#		vehicle.brakeControl = 1
	
	if playerVehicleDetected == true:
		vehicle.brakeControl = 100
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
