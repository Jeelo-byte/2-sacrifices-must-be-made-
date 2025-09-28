# dungeon_generator.gd
extends Node2D

## The TileMapLayer node where the dungeon will be drawn.
@export var tilemap_layer: TileMapLayer

## --- GENERATION PARAMETERS ---
## You can tweak these in the Inspector to change the dungeon's appearance.
@export_category("Generation")
@export var iterations = 10
@export var walk_length = 200
@export var map_size = Vector2i(100, 100)

## --- TILE INFORMATION ---
## The IDs for your wall and floor tiles from the TileSet resource.
## Open your `sample_tileset.tres` file to see the correct IDs for your tiles.
@export_category("Tiles")
@export var wall_tile_id = 0
@export var floor_tile_id = 1

# This function is called when the node enters the scene tree.
func _ready():
	generate_dungeon()

# --- THE MAIN GENERATION FUNCTION ---
func generate_dungeon():
	# 1. Error check: Make sure the TileMapLayer is assigned.
	if not tilemap_layer:
		printerr("TileMapLayer not set for DungeonGenerator.")
		return

	# 2. Clear any existing tiles.
	tilemap_layer.clear()

	# 3. Fill the entire map with wall tiles first.
	for x in range(map_size.x):
		for y in range(map_size.y):
			# We use layer 0 (the default) and the wall tile's ID.
			# The Vector2i(wall_tile_id, 0) specifies the tile atlas coordinates.
			tilemap_layer.set_cell(Vector2i(x, y), 0, Vector2i(wall_tile_id, 0))

	# 4. Start the random walk from the center of the map.
	var current_pos = map_size / 2

	# 5. Perform the random walk to create floor paths.
	var random = RandomNumberGenerator.new()
	random.randomize() # Ensure the seed is different each time

	for i in range(iterations):
		for j in range(walk_length):
			# Place a floor tile at the current position.
			tilemap_layer.set_cell(current_pos, 0, Vector2i(floor_tile_id, 0))
			# Move in a random direction.
			current_pos += _random_direction(random)

			# Ensure the walker stays within the map boundaries.
			current_pos.x = clamp(current_pos.x, 1, map_size.x - 2)
			current_pos.y = clamp(current_pos.y, 1, map_size.y - 2)

# --- HELPER FUNCTIONS ---

# Returns a random direction vector (up, down, left, or right).
func _random_direction(rng: RandomNumberGenerator) -> Vector2i:
	var direction = rng.randi_range(0, 3)
	match direction:
		0: return Vector2i.UP
		1: return Vector2i.DOWN
		2: return Vector2i.LEFT
		3: return Vector2i.RIGHT
	return Vector2i.ZERO

## Finds a random floor tile and returns its global position.
## Useful for spawning the player or items.
func get_random_floor_position() -> Vector2:
	var used_cells = tilemap_layer.get_used_cells()
	var floor_cells = []

	# Fallback if no custom data is found, just check by ID
	if floor_cells.is_empty():
		for cell in used_cells:
			var source_id = tilemap_layer.get_cell_source_id(cell)
			var atlas_coords = tilemap_layer.get_cell_atlas_coords(cell)
			# This is a basic check; you might need to adjust it based on your tileset
			if source_id == 0 and atlas_coords.x == floor_tile_id:
				floor_cells.append(cell)

	if not floor_cells.is_empty():
		var random_cell = floor_cells.pick_random()
		return tilemap_layer.map_to_local(random_cell)
	else:
		# If no floor is found, return the center of the map as a fallback
		return tilemap_layer.map_to_local(map_size / 2)
