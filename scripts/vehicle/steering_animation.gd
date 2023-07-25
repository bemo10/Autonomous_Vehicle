extends Spatial


var vehicle
var xMultiplier = 0
var yMultiplier = 0
var zMultiplier = 300


# Called when the node enters the scene tree for the first time.
func _ready():
	vehicle = self.get_parent().get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var steering = vehicle.steering
	self.rotation_degrees.x = steering * xMultiplier
	self.rotation_degrees.y = steering * yMultiplier
	self.rotation_degrees.z = -steering * zMultiplier
