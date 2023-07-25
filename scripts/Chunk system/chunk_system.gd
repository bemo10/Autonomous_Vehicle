extends Node


var children = []
var entitiesChunkCoord = {}
var chunks = {}
var activeChunksCoords = []
var chunkWidth = 200
var activeDistance = 1	# Render distance
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Game/World/PlayerVehicle")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Activate chunks around player
	activateChunksAroundPlayer()
	
	# Calculate new entity chunk and move it to that chunk
	recalculateEntityChunk()
	
	




#func initialize():
#	# Get all entities
#	var entities = get_children()
#
#	# Put entities inside chunks dictionary
#	for entity in entities:
#		var chunkX = floor(entity.entityTranslation.x / chunkWidth)
#		var chunkY = floor(entity.entityTranslation.z / chunkWidth)
#		var chunkCoord = ChunkKeyFromCoords(chunkX, chunkY)
#
#		entitiesChunkCoord[entity] = chunkCoord
#
#		if !chunks.has(chunkCoord):
#			chunks[chunkCoord] = Chunk.new(self)
#
#		chunks[chunkCoord].entities.append(entity)
#
#		#remove_child(entity)
#


func initializeEntity(entity):
	# Put entity inside chunks dictionary
	var chunkX = floor(entity.entityTranslation.x / chunkWidth)
	var chunkY = floor(entity.entityTranslation.z / chunkWidth)
	var chunkCoord = ChunkKeyFromCoords(chunkX, chunkY)
		
	entitiesChunkCoord[entity] = chunkCoord
		
	if !chunks.has(chunkCoord):
		chunks[chunkCoord] = Chunk.new(self)
	
	chunks[chunkCoord].entities.append(entity)


func activateChunksAroundPlayer():
	# Get player chunk coordinates
	var playerChunkX = floor(player.entityTranslation.x / chunkWidth)
	var playerChunkY = floor(player.entityTranslation.z / chunkWidth)
	
	# Get chunks in active distance
	var newActiveChunksCoords = []
	for x in range(playerChunkX-activeDistance, playerChunkX+activeDistance+1):
		for y in range(playerChunkY-activeDistance, playerChunkY+activeDistance+1):
			var chunkCoord = ChunkKeyFromCoords(x, y)
			if chunks.has(chunkCoord):
				newActiveChunksCoords.append(chunkCoord)
	
	# Deactivate chunks that are no longer in active distance
	for activeCoords in activeChunksCoords:
		var keepActive = false
		
		if newActiveChunksCoords.has(activeCoords):
			keepActive = true
			
		if keepActive == false:
			if chunks.has(activeCoords):
				chunks[activeCoords].deactivate()
	
	# Activate new active chunks
	for newActiveCoords in newActiveChunksCoords:
		if chunks.has(newActiveCoords) and !activeChunksCoords.has(newActiveCoords):
			chunks[newActiveCoords].activate()
			
	
	# Set active chunks list to new active chunks list
	activeChunksCoords = newActiveChunksCoords
	

#func recalculateEntityChunk():
#	# Get all entities
#	if children.empty():
#		children = get_children()
#
#	# Calculate entity chunks and move them to those chunks
#	var entity = children.pop_back()
#
#	var chunkX = floor(entity.entityTranslation.x / chunkWidth)
#	var chunkY = floor(entity.entityTranslation.z / chunkWidth)
#
#	var newChunkCoord = ChunkKeyFromCoords(chunkX, chunkY)
#	var previousChunkCoord = entitiesChunkCoord[entity]
#
#	# Remove entity from old chunk
#	chunks[previousChunkCoord].entities.remove(chunks[previousChunkCoord].entities.find(entity))
#
#	# Add entity to new chunk
#	if !chunks.has(newChunkCoord):
#		chunks[newChunkCoord] = Chunk.new(self)
#
#	chunks[newChunkCoord].entities.append(entity)
#
#	# Update entity chunk coordinate in list
#	entitiesChunkCoord[entity] = newChunkCoord
#
#	# Deactivate entity if it's new chunk is deactivated
#	if chunks[newChunkCoord].active == false:
#		#chunks[newChunkCoord].deactivate()
#		entity.deactivate()
#		remove_child(entity)
#
#

func recalculateEntityChunk():
	# Get all entities
	var entities = get_children()

	# Put entities inside chunks dictionary and remove them from tree
	for entity in entities:
		var chunkX = floor(entity.entityTranslation.x / chunkWidth)
		var chunkY = floor(entity.entityTranslation.z / chunkWidth)

		var newChunkCoord = ChunkKeyFromCoords(chunkX, chunkY)
		var previousChunkCoord = entitiesChunkCoord[entity]

		# Remove entity from old chunk
		chunks[previousChunkCoord].entities.remove(entities.find(entity))

		# Add entity to new chunk
		if !chunks.has(newChunkCoord):
			chunks[newChunkCoord] = Chunk.new(self)

		chunks[newChunkCoord].entities.append(entity)

		# Update entity chunk coordinate in list
		entitiesChunkCoord[entity] = newChunkCoord

		# Deactivate entity if it's new chunk is deactivated
		if chunks[newChunkCoord].active == false:
			#chunks[newChunkCoord].deactivate()
			entity.deactivate()
			remove_child(entity)




func ChunkKeyFromCoords(x, y):
	var chunkCoord = String(x) + "_" + String(y)
	return chunkCoord



class Chunk:
	var chunkSystem
	var active = false
	var entities = []
	
	func _init(chunkSystemReference):
		chunkSystem = chunkSystemReference
	
	func activate():
		active = true
		#print("################################# Activated")
		for entity in entities:
			if is_instance_valid(entity):
				#print("child added ", entity)
				chunkSystem.add_child(entity)
				entity.activate()
		
	
	func deactivate():
		active = false
		#print("################################# Deactivated")
		for entity in entities:
			if is_instance_valid(entity):
				#print("child removed ", entity)
				entity.deactivate()
				chunkSystem.remove_child(entity)
				pass
		
		
	
	
