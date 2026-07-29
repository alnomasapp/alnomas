extends Control

signal moved(vector: Vector2)

@export var max_radius: float = 55.0
@export var base_color: Color = Color(1, 1, 1, 0.18)
@export var knob_color: Color = Color(1, 1, 1, 0.5)

var _touch_index: int = -1
var _center: Vector2
var _knob_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	_center = size * 0.5

func _draw() -> void:
	draw_circle(_center, max_radius, base_color)
	draw_circle(_center + _knob_offset, max_radius * 0.45, knob_color)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _touch_index == -1 and get_global_rect().has_point(event.position):
				_touch_index = event.index
				_update(event.position)
				get_viewport().set_input_as_handled()
		elif event.index == _touch_index:
			_touch_index = -1
			_reset()
	elif event is InputEventScreenDrag and event.index == _touch_index:
		_update(event.position)
		get_viewport().set_input_as_handled()

func _update(global_pos: Vector2) -> void:
	var local := global_pos - get_global_rect().position - _center
	_knob_offset = local.limit_length(max_radius)
	queue_redraw()
	moved.emit(_knob_offset / max_radius)

func _reset() -> void:
	_knob_offset = Vector2.ZERO
	queue_redraw()
	moved.emit(Vector2.ZERO)

func excludes(global_pos: Vector2) -> bool:
	return get_global_rect().grow(10.0).has_point(global_pos)
