class_name PlayerKite
extends Node2D

signal line_snapped

const CONFIG := preload("res://resources/GameConfig.tres")
const EDGE_MARGIN := Vector2(30.0, 30.0)

var wind: WindSystem
var velocity := Vector2.ZERO
var tension := 0.0
var grip := 0.0
var alive := true

@onready var _ribbon: RibbonTrail = $RibbonTrail

func _physics_process(delta: float) -> void:
	if not alive:
		return
	var holding := _is_holding()
	grip = move_toward(grip, 1.0 if holding else 0.0, CONFIG.grip_lerp_speed * delta)

	var rate := CONFIG.tension_hold_rate if holding else -CONFIG.tension_release_rate
	tension = clampf(tension + rate * delta, 0.0, 1.0)
	if tension >= 1.0:
		_snap()
		return

	var desired := get_global_mouse_position()
	var accel := (desired - global_position) * CONFIG.spring_stiffness \
		- velocity * CONFIG.velocity_damping
	accel = accel.limit_length(lerpf(CONFIG.accel_max_loose, CONFIG.accel_max_tight, grip))
	if wind:
		accel += wind.force_at_time() \
			* lerpf(CONFIG.wind_loose_multiplier, CONFIG.wind_tight_multiplier, grip)
	velocity = (velocity + accel * delta).limit_length(CONFIG.max_speed)
	global_position += velocity * delta
	_clamp_to_play_area()

	if velocity.length() > 40.0:
		rotation = lerp_angle(rotation, velocity.angle() + PI / 2.0, 6.0 * delta)

	_ribbon.set_ribbon_state(state())

# 0 = loose, 1 = sharp, 2 = critical
func state() -> int:
	if tension >= CONFIG.critical_threshold:
		return 2
	if tension >= CONFIG.sharp_threshold:
		return 1
	return 0

func _is_holding() -> bool:
	return Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) \
		or Input.is_key_pressed(KEY_SPACE)

func _snap() -> void:
	alive = false
	modulate = Color(1.0, 1.0, 1.0, 0.35)
	_ribbon.set_ribbon_state(2)
	line_snapped.emit()

func _clamp_to_play_area() -> void:
	var r := get_viewport_rect()
	global_position = global_position.clamp(r.position + EDGE_MARGIN, r.end - EDGE_MARGIN)
