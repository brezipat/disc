extends Node

var ActionButton = preload("res://scenes/combat/ActionButton.tscn")
var actions_data

var team1_units = []
var team2_units = []
var units = []


var current_unit = null
var current_selected_action = null
var action_targets = []
var turn_order = []
var turn_order_index = 0


func _ready():
	randomize()
	var file = File.new()
	file.open("res://data/actions.json", File.READ)
	actions_data = parse_json(file.get_as_text())
	var square_scene = load("res://scenes/combat/Square.tscn")
	for position_index in range(1, 13):
		var position_node_name = "Position%s" % position_index
		var position_node = get_node(position_node_name)
		var unit = square_scene.instance()
		unit.position_index = position_index-1
		units.append(unit)
		if position_index <= 6:
			unit.team = 1
			team1_units.append(unit)
		else:
			unit.team = 2
			team2_units.append(unit)
		unit.connect("turn_start", self, "display_current_actions")
		unit.connect("selected_as_target", self, "target_selected")
		unit.connect("deselected_as_target", self, "target_deselected")
		position_node.add_child(unit)
	start_new_round()
	start_unit_turn()


func start_new_round():
	turn_order_index = 0
	turn_order = []
	decide_turn_order()
	for index in turn_order:
		var unit_index = turn_order[index]
		units[unit_index].update_turn_position_label(index+1)


func decide_turn_order():
	var undecided_unit_indexes = []
	for i in units.size():
		undecided_unit_indexes.append(i)
	while turn_order.size() < units.size():
		var max_initiative = -1
		var max_initiative_indexes = []
		for unit_index in undecided_unit_indexes:
			var unit = units[unit_index]
			if unit.initiative > max_initiative:
				max_initiative = unit.initiative
				max_initiative_indexes = [unit_index]
			elif unit.initiative == max_initiative:
				max_initiative_indexes.append(unit_index)
		max_initiative_indexes.shuffle()
		for index in max_initiative_indexes:
			turn_order.append(index)


func start_unit_turn():
	current_unit = units[turn_order[turn_order_index]]
	current_unit.start_turn()
	
	
func end_unit_turn():
	$TargetsSelected.visible = false
	$ConfirmActionButton.visible = false
	action_targets = []
	current_selected_action = null
	current_unit = null
	for unit in units:
		unit.new_unit_turn_reset()
	turn_order_index += 1
	if turn_order_index >= turn_order.size():
		start_new_round()
	start_unit_turn()
	

func display_current_actions(actions):
	var actions_container = get_node("ActionsBar/ActionsContainer")
	for child in actions_container.get_children():
		child.queue_free()
	for action in actions:
		var new_action_button = ActionButton.instance()
		new_action_button.icon = load("res://art/icons/%s.png" % action)
		new_action_button.connect("pressed", self, "action_selected", [action])
		actions_container.add_child(new_action_button)


func action_selected(action):
	current_selected_action = action
	update_targets_selected_label()
	$TargetsSelected.visible = true
	$ConfirmActionButton.visible = true
	reset_targets()
	stop_highlight_valid_targets()
	highlight_valid_targets()
			

func highlight_valid_targets():
	if actions_data[current_selected_action]["target_group"] == "enemy":
		for unit in units:
			unit.highlight_as_enemy(current_unit.team)
	if actions_data[current_selected_action]["target_group"] == "ally":
		for unit in units:
			unit.highlight_as_ally(current_unit.team)


func stop_highlight_valid_targets():
	for unit in units:
		if unit != current_unit:
			unit.stop_highlight_animation()


func target_selected(target_index):
	if action_targets.size() < actions_data[current_selected_action]['max_targets']:
		if !action_targets.has(target_index):
			action_targets.append(target_index)
			update_targets_selected_label()
			units[target_index].highlight_as_target()
			if action_targets.size() == actions_data[current_selected_action]['max_targets']:
				stop_highlight_valid_targets()


func target_deselected(target_index):
	if action_targets.has(target_index):
		action_targets.erase(target_index)
		update_targets_selected_label()
		units[target_index].stop_highlight_as_target()
		if action_targets.size() < actions_data[current_selected_action]['max_targets']:
			highlight_valid_targets()
	
	
func reset_targets():
	for target_index in action_targets:
		units[target_index].stop_highlight_as_target()
	action_targets = []
	update_targets_selected_label()
	
	
func update_targets_selected_label():
	$TargetsSelected.text = "%s/%s targets" % [action_targets.size(), actions_data[current_selected_action]['max_targets']]


func _on_ConfirmActionButton_pressed():
	var action = actions_data[current_selected_action]
	for target_index in action_targets:
		units[target_index].change_health(action["health_modifier"])
	end_unit_turn()
