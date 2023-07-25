extends Area


var interaction = load("res://objects/interaction.tscn")
var interactionContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	interactionContainer = get_node("/root/Game/World/Gui/Container/InteractionScrollContainer/InteractionContainer")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hit():
	var interactionInstance = interaction.instance()
	interactionInstance.accidentPrevented = false
	interactionInstance.accidentWith = "Pedestrian"
	interactionContainer.add_child(interactionInstance)
	get_parent().queue_free()
