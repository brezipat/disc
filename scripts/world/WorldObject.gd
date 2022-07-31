class_name WorldObject
extends Node2D

export var grid: Resource = preload("res://resources/world/world_grid_res.tres")

export var cell = Vector2.ZERO setget set_cell
export var size = Vector2(1, 1)


func _ready():
	self.cell = cell


func set_cell(value: Vector2):
	cell = grid.grid_clamp(value)
	position = grid.calculate_map_position(cell)
