extends RichTextLabel

var accidentPrevented = false
var reactionSpeed = 0
var accidentWith = "None"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if accidentPrevented == true:
		text = "Accident prevented!" + "\n" + "Reaction speed: " + String(reactionSpeed) + "s"
		text += "\n----------------------------------------------------"
	else:
		text = "Accident occurred!" + "\n" + "With: " + accidentWith
		text += "\n----------------------------------------------------"
