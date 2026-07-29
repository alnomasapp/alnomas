extends Control

@export var joystick_path: NodePath
@export var jump_button_path: NodePath

@onready var _joystick: Control = get_node_or_null(joystick_path)
@onready var _jump_button: Control = get_node_or_null(jump_button_path)

var _touch_index: int = -1
var _last_pos: Vector2

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _touch_index == -1 and not _is_excluded(event.position):
				_touch_index = event.index
				_last_pos = event.position
		elif event.index == _touch_index:
			_touch_index = -1
	elif event is InputEventScreenDrag and event.index == _touch_index:
		var drag_event := event as InputEventScreenDrag
		var delta := drag_event.position - _last_pos
		_last_pos = drag_event.position
		var player := get_tree().get_first_node_in_group("player")
		if player:
			player.apply_touch_look(delta)

func _is_excluded(pos: Vector2) -> bool:
	if _joystick and _joystick.excludes(pos):
		return true
	if _jump_button and _jump_button.excludes(pos):
		return true
	return false
