extends RichTextLabel


var vehicle


# Called when the node enters the scene tree for the first time.
func _ready():
	vehicle = get_node("/root/Game/World/PlayerVehicle/Vehicle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = int(vehicle.linear_velocity.length() / 1.12) as String + " Km/h"
