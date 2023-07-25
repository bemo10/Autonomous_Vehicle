extends Spatial



var character1 = preload('res://objects/characters/character1.tscn')
var character2 = preload('res://objects/characters/character2.tscn')
var character3 = preload('res://objects/characters/character3.tscn')
var character4 = preload('res://objects/characters/character4.tscn')


# Called when the node enters the scene tree for the first time.
func _ready():
	var characters = [character1, character2, character3, character4]
	add_child(characters[randi() % 4].instance())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
