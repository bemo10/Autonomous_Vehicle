extends Node

var osmParser = load("res://scripts/world builder/osm_parser.gd").new()

var osmData = null


# Called when the node enters the scene tree for the first time.
func _ready():
	osmData = osmParser.parseOsm()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
