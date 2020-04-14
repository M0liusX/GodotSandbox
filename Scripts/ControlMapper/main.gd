extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var actionToMap = null

const axis0 = ["left", "right"] #hAxis
const axis1 = ["up", "down"] #vAxis
var vAxis = 0 
var hAxis = 0

func fix_motion(action, event):
	if action in axis0:
		hAxis = event.axis_value * (axis0.find(action)*2 - 1)
	elif action in axis1:
		vAxis = event.axis_value * (axis1.find(action)*2 - 1)
	
func get_action(event):
	for action in InputMap.get_actions():
		if InputMap.event_is_action(event, action):
			if "ui" in action:
				return
			return action
	return null

func _input(event):
	# Return if not a press or an input event
	if not event.is_pressed():
		return
	if not event is InputEvent:
		return
	
	# add to map if wanted
	if actionToMap != null:
		var currentAction = get_action(event)
		if currentAction != null:
			InputMap.action_erase_event(currentAction, event)
		if event is InputEventJoypadMotion:
			fix_motion(actionToMap, event)
		InputMap.action_add_event(actionToMap, event)
		actionToMap = null
	
	# print action
	var thisAction = get_action(event)
	if thisAction != null:
		if event is InputEventJoypadMotion:
			if thisAction in axis0:
				print(axis0[(event.axis_value*hAxis + 1)/2])
			elif thisAction in axis1:
				print(axis1[(event.axis_value*vAxis + 1)/2])
		else:
			print(thisAction)
		
func _on_Button_pressed(action):
	actionToMap = action
