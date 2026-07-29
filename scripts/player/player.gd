extends CharacterBody3D

const SPEED := 4.5
const JUMP_VELOCITY := 4.8
const GRAVITY := 18.0
const MOUSE_SENSITIVITY := 0.0035
const TOUCH_LOOK_SENSITIVITY := 0.006
const PITCH_MIN := deg_to_rad(-60.0)
const PITCH_MAX := deg_to_rad(70.0)

@onready var spring_arm: SpringArm3D = $SpringArm3D

var _joystick_input := Vector2.ZERO
var _jump_requested := false
var _mouse_captured := false

func _ready() -> void:
	add_to_group("player")
	if not DisplayServer.is_touchscreen_available():
		_set_mouse_captured(true)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and _mouse_captured:
		_apply_look(event.relative * MOUSE_SENSITIVITY)
	elif event.is_action_pressed("ui_cancel"):
		_set_mouse_captured(not _mouse_captured)

func _set_mouse_captured(captured: bool) -> void:
	_mouse_captured = captured
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if captured else Input.MOUSE_MODE_VISIBLE

func set_joystick_input(vector: Vector2) -> void:
	_joystick_input = vector

func request_jump() -> void:
	_jump_requested = true

func apply_touch_look(pixel_delta: Vector2) -> void:
	_apply_look(pixel_delta * TOUCH_LOOK_SENSITIVITY)

func _apply_look(delta: Vector2) -> void:
	rotate_y(-delta.x)
	spring_arm.rotation.x = clampf(spring_arm.rotation.x - delta.y, PITCH_MIN, PITCH_MAX)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	if (_jump_requested or Input.is_action_just_pressed("jump")) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	_jump_requested = false

	var input_vector := _joystick_input
	if input_vector == Vector2.ZERO:
		input_vector = Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	var move_direction := (transform.basis * Vector3(input_vector.x, 0.0, input_vector.y)).normalized()
	velocity.x = move_direction.x * SPEED
	velocity.z = move_direction.z * SPEED

	move_and_slide()
