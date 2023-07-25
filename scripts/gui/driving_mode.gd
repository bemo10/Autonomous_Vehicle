extends RichTextLabel


var playerVehicleAi

# Called when the node enters the scene tree for the first time.
func _ready():
	playerVehicleAi = get_node("/root/Game/World/PlayerVehicle/AiVehicleController")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Driving Mode: "
	if playerVehicleAi.aiVehicleControlEnabled and !playerVehicleAi.aiVehicleControlTemporarilyDisabled:
		text += "Autonomous"
	else:
		text += "Manual"
