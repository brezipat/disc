extends Area2D

signal turn_start(actions)
signal selected_as_target(position_index)
signal deselected_as_target(position_index)

var initiative = 50
var max_health = 50
var current_health = 50
var team = 1
var turn_position = 1

var actions = ["fireball", "bolt", "heal"]
var position_index = null

var has_turn = false
var is_valid_target = false
var is_targeted = false
var is_highlighted_as_enemy = false
var is_highlighted_as_ally = false


func _ready():
	$HealthBar.max_value = max_health
	update_health()
	
	
func change_health(health_change):
	current_health =  min(max(0, current_health + health_change), max_health)
	update_health()
	
	
func update_health():
	$HealthBar.value = current_health
	$HealthBar/Label.text = "%s/%s" % [current_health, max_health]
	
	
func update_turn_position_label(position):
	turn_position = position
	$TurnOrder.text = "%s" % turn_position
	
	
func start_turn():
	has_turn = true
	$GlowAnimator.play("UnitTurnAnimation")
	$Highlight.visible = true
	emit_signal("turn_start", actions)


func highlight_as_enemy(current_units_team):
	if not has_turn:
		if team != current_units_team:
			$Highlight.visible = true
			$GlowAnimator.play("EnemyHighlightAnimation")
			is_valid_target = true
			is_highlighted_as_enemy = true
		else:
			stop_highlight_animation()
			is_valid_target = false


func highlight_as_ally(current_units_team):
	if not has_turn:
		if team == current_units_team:
			$Highlight.visible = true
			$GlowAnimator.play("AllyHighlightAnimation")
			is_valid_target = true
			is_highlighted_as_ally = true
		else:
			stop_highlight_animation()
			is_valid_target = false


func stop_highlight_animation():
	$Highlight.visible = false
	$GlowAnimator.stop()
	is_highlighted_as_enemy = false
	is_highlighted_as_ally = false
	

func highlight_as_target():
	is_targeted = true
	if is_highlighted_as_enemy:
		$SolidHighlight.modulate = "e32525"
	elif is_highlighted_as_ally:
		$SolidHighlight.modulate = "138912"
	$SolidHighlight.visible = true
	
	
func stop_highlight_as_target():
	$SolidHighlight.visible = false
	is_targeted = false
	

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if is_valid_target and event.is_action_pressed("mouse_click"):
		if not is_targeted:
			emit_signal("selected_as_target", position_index)
		else:
			emit_signal("deselected_as_target", position_index)


func new_unit_turn_reset():
	stop_highlight_animation()
	stop_highlight_as_target()
	is_valid_target = false
	has_turn = false

#func _on_Area2D_mouse_entered():
#	if not has_turn and not is_targeted:
#		is_howered = true
#		$Highlight.visible = true
#		$GlowAnimator.play("EnemyHighlightAnimation")
#
#
#func _on_Area2D_mouse_exited():
#	if not has_turn and not is_targeted:
#		is_howered = false
#		$Highlight.visible = false
#		$GlowAnimator.stop()


#func _on_Area2D_input_event(_viewport, event, _shape_idx):
#	if is_howered and event.is_action_pressed("mouse_click"):
#		is_targeted = not is_targeted
#		if is_targeted:
#			$GlowAnimator.stop()
#			$Highlight.modulate = "e32525"
#		else:
#			$GlowAnimator.play()
