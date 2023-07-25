extends Camera


var cameraSpeed = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	var xInput = -Input.get_axis("right", "left")
#	var zInput = -Input.get_axis("backward", "forward")
#
#	self.global_translate(Vector3(xInput * cameraSpeed, 0, zInput * cameraSpeed))


func _input(event):
	if event is InputEventMouseMotion:
		var movement = event.relative
		self.global_translate(Vector3(movement.x, 0, movement.y))
