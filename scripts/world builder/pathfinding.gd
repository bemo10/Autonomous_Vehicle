extends Node




var pathfinding


# Called when the node enters the scene tree for the first time.
func _ready():
	var data = get_node("../OsmData").osmData
	var nodes = data[0]
	var nodeGraph = get_node("../NodeGraphBuilder").nodeGraph
	pathfinding = Pathfinding.new(nodeGraph)
	pathfinding.buildAStarFromGraph(nodeGraph, nodes)
	
	# TESTS
#	var myPath
#	myPath = parthfinding.getIdPath(6041313239, 6041313238)
#	print("\nPath between nodes '6041313239' and '6041313238':")
#	print(myPath)
#	myPath = parthfinding.getIdPath(1303430343, 9739474150)
#	print("\nPath between nodes '1303430343' and '9739474150':")
#	print(myPath)
#	myPath = parthfinding.getIdPath(8299800765, 6227505782)
#	print("\nPath between nodes '8299800765' and '6227505782':")
#	print(myPath)
	

class Pathfinding:
	var astar = AStar.new()
	var newIds = {}
	var originalIds = {}
	var nodeGraph = null
	
	func _init(graph):
		nodeGraph = graph
		getNewOriginalNodeIds()
	
	func buildAStarFromGraph(nodeGraph, nodes):
		var graphNodes = nodeGraph.graphNodes
		# Add all nodes to Astar graph
		for node in graphNodes:
			if !astar.has_point(getNewId(node)):
				astar.add_point(getNewId(node), Vector3(nodes[node][0], 0, nodes[node][1]))
		# Add connections between nodes
		for node1 in graphNodes:
			for node2 in graphNodes[node1]:
				astar.connect_points(getNewId(node1), getNewId(node2))
	
	func getNewOriginalNodeIds():
		var graphNodes = nodeGraph.graphNodes
		var i = 0
		for node in graphNodes:
			newIds[node] = i
			originalIds[i] = node
			i += 1
	
	func getIdPath(fromId, toId):
		var truePath = []
		var path = astar.get_id_path(getNewId(fromId), getNewId(toId))
		for id in path:
			truePath.append(getOriginalId(id))
		return truePath
	
	func getNewId(id):
		return newIds[id]
	
	func getOriginalId(id):
		return originalIds[id]



