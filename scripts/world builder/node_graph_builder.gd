extends Node



var nodeGraph = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var data = get_node("../OsmData").osmData
	var nodes = data[0]
	var pathways = data[2]
	
	nodeGraph = NodeGraph.new()
	nodeGraph.buildGraphFromPathways(pathways, nodes)
	
	



class NodeGraph:
	var graphNodes = {}
	
	func _init():
		pass
	
	func buildGraphFromPathways(pathways, nodes):
		for path in pathways.values():
			if path.isDrivable:
				for i in range(1, path.nodes.size()):
					var node1 = path.nodes[i-1]
					var node2 = path.nodes[i]
					var point1 = Vector2(nodes[node1][0], nodes[node1][1])
					var point2 = Vector2(nodes[node2][0], nodes[node2][1])
					var distance  = point1.distance_to(point2)
					if !graphNodes.has(node1):
						graphNodes[node1] = {}
					if !graphNodes.has(node2):
						graphNodes[node2] = {}
					graphNodes[node1][node2] = distance
					graphNodes[node2][node1] = distance










