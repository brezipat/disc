extends Node2D
export var grid: Resource = preload("res://resources/world/world_grid_res.tres")
var unit = preload("res://scenes/world/WorldUnit.tscn")


var grid_data = []


func _ready():
	var walkable_cells = []
	for row_i in grid.size.x:
		for col_i in grid.size.y:
			grid_data.append("empty")
			walkable_cells.append(Vector2(row_i, col_i))
	var unit_instance = unit.instance()
	place_object_on_grid(unit_instance, Vector2(10, 10))
	var pathfinder = WorldPathfinder.new(grid, walkable_cells)
	print(pathfinder.calculate_point_path(Vector2(5,5), Vector2(8,5)))


func place_object_on_grid(object, grid_cell: Vector2):
	var cell_index = grid.as_index(grid_cell)
	if grid_data[cell_index] == "empty":
		add_child(object)
		object.cell = grid.grid_clamp(grid_cell)
		grid_data[cell_index] = object
