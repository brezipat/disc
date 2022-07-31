tool
class_name Cursor
extends Node2D

signal accept_pressed(cell)
signal moved(new_cell)

export var grid: Resource = preload("res://resources/world/world_grid_res.tres")
var cell = Vector2.ZERO setget set_cell


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.cell = grid.calculate_grid_coordinates(event.position)
	elif event.is_action_pressed("mouse_click"):
		emit_signal("accept_pressed", cell)
		get_tree().set_input_as_handled()


func _draw() -> void:
	draw_rect(Rect2(-grid.cell_size / 2, grid.cell_size), Color.aliceblue, false, 2.0)


func set_cell(value: Vector2) -> void:
	var new_cell: Vector2 = grid.grid_clamp(value)
	if new_cell.is_equal_approx(cell):
		return
	cell = new_cell
	position = grid.calculate_map_position(cell)
	emit_signal("moved", cell)
