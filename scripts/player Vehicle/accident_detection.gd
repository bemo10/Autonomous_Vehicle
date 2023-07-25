extends Area

onready var hitEffect = get_node("/root/Game/World/Gui/Container/HitEffect")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


func _physics_process(delta):
	# Get overlapping NPCs
	var overlapNpcs = get_overlapping_areas()

	for npcArea in overlapNpcs:
		if npcArea.get_collision_layer_bit(6) == true:
			npcArea.hit()
			hitEffect.hit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
