class_name RibbonTrail
extends Line2D

const CONFIG := preload("res://resources/GameConfig.tres")

# State must never read through colour alone — width and pulse carry it too.
const COLOR_LOOSE := Color(0.99, 0.95, 0.85, 0.55)
const COLOR_SHARP := Color(1.0, 0.72, 0.18, 0.95)
const COLOR_CRITICAL := Color(1.0, 0.32, 0.18, 1.0)

var _ages: Array[float] = []
var _accum := 0.0
var _state := 0
var _pulse := 0.0

func _ready() -> void:
	joint_mode = Line2D.LINE_JOINT_ROUND
	begin_cap_mode = Line2D.LINE_CAP_ROUND
	end_cap_mode = Line2D.LINE_CAP_ROUND
	var taper := Curve.new()
	taper.add_point(Vector2(0.0, 0.15))
	taper.add_point(Vector2(1.0, 1.0))
	width_curve = taper
	default_color = COLOR_LOOSE
	width = CONFIG.ribbon_width

func _physics_process(delta: float) -> void:
	var kite := get_parent() as PlayerKite
	if kite and kite.alive:
		_accum += delta
		var interval := 1.0 / CONFIG.ribbon_sample_hz
		while _accum >= interval:
			_accum -= interval
			add_point(kite.global_position)
			_ages.append(0.0)
	for i in _ages.size():
		_ages[i] += delta
	while _ages.size() > 0 and _ages[0] > CONFIG.ribbon_history_sec:
		_ages.remove_at(0)
		remove_point(0)

	_pulse += delta * 14.0
	match _state:
		0:
			default_color = COLOR_LOOSE
			width = CONFIG.ribbon_width * 0.8
		1:
			default_color = COLOR_SHARP
			width = CONFIG.ribbon_width * 1.15
		2:
			default_color = COLOR_CRITICAL
			width = CONFIG.ribbon_width * (1.3 + 0.35 * sin(_pulse))

func set_ribbon_state(s: int) -> void:
	_state = s
