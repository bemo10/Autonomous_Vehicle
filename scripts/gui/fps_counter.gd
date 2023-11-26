extends RichTextLabel




# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "FPS " + String(Engine.get_frames_per_second())
	
	# Print performence metrics
#	print("--------------------------")
#	var pedestrians = get_node("/root/Game/World/PedestrianManager/ChunkSystem").get_child_count();
#	var vehicles = get_node("/root/Game/World/NpcVehicleManager/ChunkSystem").get_child_count();
#	print("Pedestrians ", pedestrians)
#	print("Vehicles ", vehicles)
#	print("Object Count ", Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
#	print("FPS ", Engine.get_frames_per_second())
#	print("Frame Time ", Performance.get_monitor(Performance.TIME_PROCESS))
#	print("Memory ", Performance.get_monitor(Performance.MEMORY_STATIC))
#	print("--------------------------")
