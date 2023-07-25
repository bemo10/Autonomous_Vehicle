extends Area



## Called when the node enters the scene tree for the first time.
func _ready():
	#set_monitoring(true)
	#set_monitorable(true)
	pass

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Get overlapping buildings array
	#var overlapBuildings = get_overlapping_bodies()
	var overlapBuildings = get_overlapping_bodies()
	if !overlapBuildings.empty():
		print(overlapBuildings)
		overlapBuildings[0].get_parent().queue_free()
