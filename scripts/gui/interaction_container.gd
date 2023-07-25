extends ScrollContainer


var container
var scoreObject
var scrollSpeed = 50



# Called when the node enters the scene tree for the first time.
func _ready():
	container = get_node("InteractionContainer")
	scoreObject = container.get_node("Score")
	
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("ui_scroll_up"):
		scroll_vertical -= scrollSpeed
	if Input.is_action_just_released("ui_scroll_down"):
		scroll_vertical += scrollSpeed
	if Input.is_action_just_pressed("ui_cancel"):
		if visible == true:
			visible = false
		else:
			visible = true
	
	# Calculate score
	var interactions = container.get_children()
	interactions.pop_front()
	
	var score = 0
	for interaction in interactions:
		if interaction.accidentPrevented == true:
			score += 40 / max(interaction.reactionSpeed, 0.01)
		else:
			score -= 50
	scoreObject.score = score
	
	# Delete all interactions
	if Input.is_action_just_pressed("ui_delete"):
		for child in container.get_children():
			if child != scoreObject:
				child.queue_free()
	
	
