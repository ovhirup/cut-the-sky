class_name Kite
extends Node2D

signal died(reason: String)

const CONFIG := preload("res://resources/GameConfig.tres")
const EDGE_MARGIN := Vector2(30.0, 30.0)

var wind: WindSystem
var velocity := Vector2.ZERO
var tension := 0.0
var grip := 0.0
var alive := true

@onready var ribbon: RibbonTrail = $RibbonTrail

func _physics_process(delta: float) -> void:
	if not alive:
		return
	var holding := _wants_tighten()
	grip = move_toward(grip, 1.0 if holding else 0.0, CONFIG.grip_lerp_speed * delta)

	var rate := CONFIG.tension_hold_rate if holding else -CONFIG.tension_release_rate
	tension = clampf(tension + rate * delta, 0.0, _tension_max())
	if tension >= 1.0:
		_on_snap()
		return

	var accel := (_desired_position() - global_position) * CONFIG.spring_stiffness \
		- velocity * CONFIG.velocity_damping
	accel = accel.limit_length(
		lerpf(CONFIG.accel_max_loose, CONFIG.accel_max_tight, grip) * _accel_scale())
	if wind:
		accel += wind.force_at_time() \
			* lerpf(CONFIG.wind_loose_multiplier, CONFIG.wind_tight_multiplier, grip)
	velocity = (velocity + accel * delta).limit_length(CONFIG.max_speed * _speed_scale())
	global_position += velocity * delta
	var r := get_viewport_rect()
	global_position = global_position.clamp(r.position + EDGE_MARGIN, r.end - EDGE_MARGIN)

	if velocity.length() > 40.0:
		rotation = lerp_angle(rotation, velocity.angle() + PI / 2.0, 6.0 * delta)

	ribbon.set_ribbon_state(state())

# 0 = loose, 1 = sharp, 2 = critical
func state() -> int:
	if tension >= CONFIG.critical_threshold:
		return 2
	if tension >= CONFIG.sharp_threshold:
		return 1
	return 0

func die_cut() -> void:
	if not alive:
		return
	alive = false
	_on_cut_down()

func _desired_position() -> Vector2:
	return global_position

func _wants_tighten() -> bool:
	return false

func _tension_max() -> float:
	return 1.0

func _accel_scale() -> float:
	return 1.0

func _speed_scale() -> float:
	return 1.0

func _on_snap() -> void:
	pass

func _on_cut_down() -> void:
	pass
