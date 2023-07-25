extends Node

#var osmParser = load("res://scripts/osm_parser.gd").new()
#var worldData = load("res://scripts/world_builder.gd").WorldData.new()
#var rng = RandomNumberGenerator.new()
var building_mat = preload('res://scenes/mats/mat_building.tres')
var pathway_mat = preload('res://scenes/mats/mat_pathway.tres')
var test_mat = preload('res://scenes/mats/mat_test.tres')
var building_mat1 = preload('res://scenes/mats/mat_building1.tres')
var building_mat2 = preload('res://scenes/mats/mat_building2.tres')
var building_mat3 = preload('res://scenes/mats/mat_building3.tres')
var building_mat4 = preload('res://scenes/mats/mat_building4.tres')
var building_mat5 = preload('res://scenes/mats/mat_building5.tres')

var buildingLayerNode
var pathwaysLayerNode
var pathwaysAreasLayerNode

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get osm data
	var data = get_node("../OsmData").osmData
	
	#var data = worldData.getOsmData()
	var nodes = data[0]
	var buildings = data[1]
	var pathways = data[2]
	
	# Create paths and building layers
	buildingLayerNode = Spatial.new()
	buildingLayerNode.set_name("BuildingsLayer")
	self.add_child(buildingLayerNode)
	
	pathwaysLayerNode = Spatial.new()
	pathwaysLayerNode.set_name("PathwaysLayer")
	self.add_child(pathwaysLayerNode)
	
	pathwaysAreasLayerNode = Spatial.new()
	pathwaysAreasLayerNode.set_name("PathwaysAreasLayer")
	self.add_child(pathwaysAreasLayerNode)
	
	# Create building mesh instances
	createBuildings(buildings, nodes)
	
	# Remove buildings that overlap pathways
	removeOverlappingBuildings(pathways, nodes)
	
	# Create pathway mesh instances
	createPathways(pathways, nodes)
	
	
	# test
#	var segment = getPathwaySegmentVertices3D(Vector3(0, 0, 0), Vector3(100, 0, 0), 10, 1)
#	createMeshInstance(segment)




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func createMeshInstance(vertices):
	# Initialize arraymesh
	var arrMesh = []
	arrMesh.resize(ArrayMesh.ARRAY_MAX)
	
	# Add vertices to arraymesh
	arrMesh[ArrayMesh.ARRAY_VERTEX] = PoolVector3Array(vertices)
	
	# Create array mesh surface and mesh instance
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrMesh)
	
	var m = MeshInstance.new()
	m.mesh = mesh
	
	return m



func createPathways(pathways, nodes):
	var height = 0.1
	for key in pathways:
		var path = pathways[key]
		if path.isDrivable:
			var pathNodes = path.nodes
			var thickness = path.thickness
			var pathVertices = []
			for i in range(1, pathNodes.size()):
				var node1 = Vector2(nodes[pathNodes[i-1]][0], nodes[pathNodes[i-1]][1])
				var node2 = Vector2(nodes[pathNodes[i]][0], nodes[pathNodes[i]][1])
				var segment = getPathwaySegmentVertices3D(node1, node2, thickness, height)
				pathVertices.append_array(segment)
				# Draw circle at the start and end of a segment to round edges
				var circle1 = getCircleVertices(Vector3(node1[0], height, node1[1]), thickness, 12)
				var circle2 = getCircleVertices(Vector3(node2[0], height, node2[1]), thickness, 12)
				pathVertices.append_array(circle1)
				pathVertices.append_array(circle2)
			var m = createMeshInstance(pathVertices)
			self.get_node("PathwaysLayer").add_child(m)
			m.set_surface_material(0, pathway_mat)
#		if path.type == "primary":
#			m.set_surface_material(0, test_mat)


func removeOverlappingBuildings(pathways, nodes):
	var height = 0.1
	for key in pathways:
		var path = pathways[key]
		if path.isDrivable:
			var pathNodes = path.nodes
			var buildingRemovalThicknessMultiplier = 1.6
			var thickness = path.thickness * buildingRemovalThicknessMultiplier
			for i in range(1, pathNodes.size()):
				var pathVertices = []
				var node1 = Vector2(nodes[pathNodes[i-1]][0], nodes[pathNodes[i-1]][1])
				var node2 = Vector2(nodes[pathNodes[i]][0], nodes[pathNodes[i]][1])
				var segment = getPathwaySegmentVertices3D(node1, node2, thickness, height)
				pathVertices.append_array(segment)
				# Draw circle at the start and end of a segment to round edges
				var circle1 = getCircleVertices(Vector3(node1[0], height, node1[1]), thickness, 12)
				var circle2 = getCircleVertices(Vector3(node2[0], height, node2[1]), thickness, 12)
				pathVertices.append_array(circle1)
				pathVertices.append_array(circle2)
				var m = createMeshInstance(pathVertices)
				self.get_node("PathwaysAreasLayer").add_child(m)
				m.set_surface_material(0, pathway_mat)
				m.create_convex_collision()
				createOverlapRemovalArea(m)


func getPathwaySegmentVertices(node1, node2, thickness):
	var pathVector = Vector2(node2[0]-node1[0], node2[1]-node1[1]).normalized() * thickness
	var pathTangent = pathVector.tangent()
	var v1 = Vector2(node1[0]+pathTangent[0], node1[1]+pathTangent[1])
	var v2 = Vector2(node2[0]+pathTangent[0], node2[1]+pathTangent[1])
	var v3 = Vector2(node2[0]-pathTangent[0], node2[1]-pathTangent[1])
	var v4 = Vector2(node1[0]-pathTangent[0], node1[1]-pathTangent[1])
	return [v1, v2, v3, v3, v4, v1]


func getPathwaySegmentVertices3D(node1, node2, thickness, height):
	var segment = getPathwaySegmentVertices(node1, node2, thickness)
	var segmentV3 = []
	for vertex in segment:
		segmentV3.append(vector2ToVector3withHeight(vertex, height))
	return segmentV3

func getCircleVertices(center, radius, subdivisions):
	var vertices = []
	var angleAdd = 2 * PI / subdivisions
	for i in range(subdivisions):
		var v1 = center + Vector3(radius,0, 0).rotated(Vector3(0, 1, 0), i * angleAdd)
		var v2 = center + Vector3(radius, 0, 0).rotated(Vector3(0, 1, 0), (i+1) * angleAdd)
		vertices.append_array([center, v2, v1])
	return vertices

func vector2ToVector3withHeight(vector2, height):
	return Vector3(vector2[0], height, vector2[1])




func createBuildings(buildings, nodes):
	var mats = [building_mat1, building_mat2, building_mat3, building_mat4, building_mat5]
	
	for key in buildings:
		var buildingVertices = []
		var wallVertices = []
		var roofVertices = []
		var building = buildings[key]
		var baseHeight = 50
		var heightMultiplier = 25
		var height = baseHeight + (building.levels - 1) * heightMultiplier
		var buildingNodes = fixPolygonVertexClockwise(building.nodes, nodes)
		wallVertices = getWallsVerticesArray(buildingNodes, nodes, height)
		roofVertices = getRoofVerticesArray(buildingNodes, nodes, height)
		buildingVertices = wallVertices + roofVertices
		
		# Create mesh instance
		var m = createMeshInstance(buildingVertices)
		self.get_node("BuildingsLayer").add_child(m)
		
		# Set random building material
		m.set_surface_material (0, mats[randi() % mats.size()])
		
		# Building collision
		m.create_trimesh_collision()
		m.get_child(0).name = "concave trimesh collision"
		m.create_convex_collision()
		
		# Convex collision is used for removing overlap between buildings and pathways
		# (collision is deleted after)
		m.get_child(1).name = "convex collision"
		m.get_child(1).queue_free()
		
		# Building collision layer and mask
		setBuildingCollisionLayer(m)


func fixPolygonVertexClockwise(polygonNodes, nodes):
	var vertices = PoolVector2Array()
	for polyNode in polygonNodes:
		vertices.append(Vector2(nodes[polyNode][0], nodes[polyNode][1]))
	if Geometry.is_polygon_clockwise (vertices) == false:
		polygonNodes.invert()
	return polygonNodes

func getWallsVerticesArray(building, nodes, height):
	var vertices = []
	for i in range(1, building.size()):
		var n1 = nodes[building[i-1]]
		var n2 = nodes[building[i]]
		
		var v1 = Vector3(n2[0], 0, n2[1])
		var v2 = Vector3(n1[0], 0, n1[1])
		var v3 = Vector3(n1[0], height, n1[1])
		var v4 = Vector3(n2[0], height, n2[1])
		
		vertices.append_array( [v1, v2, v3, v3, v4, v1] )
	return vertices

func getRoofVerticesArray(building, nodes, height):
	# Remove last vertex bacause it's the same as first vertex
	building.pop_back()
	
	var polygon = PoolVector2Array()
	for node in building:
		polygon.append(Vector2(nodes[node][0], nodes[node][1]))
	
	var verticesIndices = Geometry.triangulate_polygon(polygon)
	
	var vertices = []
	for i in verticesIndices:
		vertices.append(Vector3(polygon[i][0], height, polygon[i][1]))
	
	return vertices
	

func setBuildingCollisionLayer(building):
	var staticBody = building.get_child(0)
	# Add it to "Building" collision layer
	staticBody.set_collision_layer_bit(2, true)
	staticBody.set_collision_layer_bit(0, false)


func createOverlapRemovalArea(pathway):
	# Get pathway colision shape
	var colShape = pathway.get_child(0).get_child(0)

	# Create 3d area for pathway
	var area = Area.new()
	pathwaysAreasLayerNode.add_child(area)

	# Make collision shape a child to the 3d area and delete it's previous parent
	var newColShape = colShape.duplicate()
	area.add_child(newColShape)
	
	# delete pathway mesh and it's staticbody child
	pathway.queue_free()

	# Attach script to area that deletes overlapping buildings (not possible to delete them here)
	area.set_script(load("res://scripts/world builder/delete_overlapping_buildings.gd"))
	area._ready()
	area.set_process(true)
	area.set_physics_process(true)

	



