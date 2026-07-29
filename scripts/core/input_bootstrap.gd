extends Node

func _init() -> void:
	_bind("move_forward", KEY_W, KEY_UP)
	_bind("move_back", KEY_S, KEY_DOWN)
	_bind("move_left", KEY_A, KEY_LEFT)
	_bind("move_right", KEY_D, KEY_RIGHT)
	_bind("jump", KEY_SPACE)

func _bind(action: String, primary: Key, secondary: Key = KEY_NONE) -> void:
	if InputMap.has_action(action):
		return
	InputMap.add_action(action)
	var event_primary := InputEventKey.new()
	event_primary.physical_keycode = primary
	InputMap.action_add_event(action, event_primary)
	if secondary != KEY_NONE:
		var event_secondary := InputEventKey.new()
		event_secondary.physical_keycode = secondary
		InputMap.action_add_event(action, event_secondary)
