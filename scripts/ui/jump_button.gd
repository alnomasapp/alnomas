extends Control

signal pressed_jump

@export var color_idle: Color = Color(1, 1, 1, 0.22)
@export var color_pressed: Color = Color(1, 1, 1, 0.5)

var _touch_index: int = -1

func _draw() -> void:
	var radius := size.x * 0.5
	draw_circle(size * 0.5, radius, color_pressed if _touch_index != -1 else color_idle)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _touch_index == -1 and get_global_rect().has_point(event.position):
			_touch_index = event.index
			queue_redraw()
			pressed_jump.emit()
			get_viewport().set_input_as_handled()
		elif not event.pressed and event.index == _touch_index:
			_touch_index = -1
			queue_redraw()

func excludes(global_pos: Vector2) -> bool:
	return get_global_rect().grow(10.0).has_point(global_pos)
