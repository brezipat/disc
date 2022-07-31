class_name WorldPathfinder
extends Reference


const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

var _grid: Resource
var _astar := AStar2D.new()


func _init(grid: WorldMapGrid, walkable_cells: Array) -> void:
	_grid = grid
	var cell_mappings := {}
	for cell in walkable_cells:
		cell_mappings[cell] = _grid.as_index(cell)
	_add_and_connect_points(cell_mappings)


func _add_and_connect_points(cell_mappings: Dictionary) -> void:
	for point in cell_mappings:
		_astar.add_point(cell_mappings[point], point)
	for point in cell_mappings:
		_connect_to_neighbours(point, cell_mappings)


func _connect_to_neighbours(cell: Vector2, cell_mappings: Dictionary):
	for direction in DIRECTIONS:
		var neighbor: Vector2 = cell + direction
		if not cell_mappings.has(neighbor):
			continue
		if not _astar.are_points_connected(cell_mappings[cell], cell_mappings[neighbor]):
			_astar.connect_points(cell_mappings[cell], cell_mappings[neighbor])


func calculate_point_path(start: Vector2, end: Vector2) -> PoolVector2Array:
	var start_index: int = _grid.as_index(start)
	var end_index: int = _grid.as_index(end)
	if _astar.has_point(start_index) and _astar.has_point(end_index):
		return _astar.get_point_path(start_index, end_index)
	else:
		return PoolVector2Array()



