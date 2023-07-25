extends Node


var vehicle
var entityTranslation

# Called when the node enters the scene tree for the first time.
func _ready():
	vehicle = get_node("Vehicle")
	
	# Change collision mask
	get_node("Vehicle").set_collision_mask_bit(2, true)
	
	# Get vehicle translation (needed for chunk system)
	entityTranslation = vehicle.translation
	

func _process(delta):
	# Get vehicle translation (needed for chunk system)
	entityTranslation = vehicle.translation
	

