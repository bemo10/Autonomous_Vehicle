extends Area


var self_delete = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Collision layer
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(3, true)	# Pathways
	# Collision mask
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(2, true)	# buildings
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Get overlapping buildings array
	var overlapBuildings = get_overlapping_bodies()
	
	# Delete overlapping buildings
	for building in overlapBuildings:
		building.get_parent().queue_free()
	
	
	
func _process(delta):
	# Delete self (no longer needed)
	#queue_free()
	
	# Remove pathways areas layer from tree (deactivate it and it's children)
	var pathwayAreasLayer = get_parent()
	pathwayAreasLayer.get_parent().remove_child(pathwayAreasLayer)
	
	pass
	
	
	# Delete self next frame (no longer needed)
#	if self_delete == true:
#		get_parent().queue_free()
#	self_delete = true
	
