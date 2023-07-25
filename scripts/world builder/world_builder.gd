extends Node

var geometryBuilder = load("res://objects/geometry_builder.tscn")
var osmData = load("res://objects/osm_data.tscn")
var nodeGraphBuilder = load("res://objects/node_graph_builder.tscn")
var pathfinding = load("res://objects/pathfinding.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var od = osmData.instance()
	od.set_name("OsmData")
	add_child(od)
	
	var gb = geometryBuilder.instance()
	gb.set_name("GeometryBuilder")
	add_child(gb)
	
	var ngb = nodeGraphBuilder.instance()
	ngb.set_name("NodeGraphBuilder")
	add_child(ngb)
	
	var p = pathfinding.instance()
	p.set_name("Pathfinding")
	add_child(p)
	


