class_name EnemyKite
extends Kite

# One controller, parameter variations only — no bespoke AI subclasses.
@export var preferred_altitude := 0.4      # fraction of screen height
@export var oscillation_rate := 0.6
@export var oscillation_width := 260.0
@export var aggression := 0.5              # bias toward the player
@export var tighten_rhythm := 0.35         # fraction of a cycle spent tight
@export var rhythm_rate := 0.7

var _t := 0.0
var _phase := 0.0
var _target: Node2D

func setup(target: Node2D, seed_phase: float) -> void:
	_target = target
	_phase = seed_phase

func _physics_process(delta: float) -> void:
	_t += delta
	super._physics_process(delta)

func _desired_position() -> Vector2:
	var r := get_viewport_rect()
	var base_x := r.size.x * 0.5 \
		+ sin(_t * oscillation_rate + _phase) * oscillation_width
	var base_y := r.size.y * preferred_altitude \
		+ cos(_t * oscillation_rate * 0.7 + _phase) * (oscillation_width * 0.4)
	var wander := Vector2(base_x, base_y)
	if is_instance_valid(_target) and (_target as Kite).alive:
		return wander.lerp(_target.global_position, aggression * 0.6)
	return wander

func _wants_tighten() -> bool:
	# Rhythmic tightening so enemies present sharp windows, not constant threat.
	return fposmod(_t * rhythm_rate + _phase, 1.0) < tighten_rhythm

func _tension_max() -> float:
	# Enemies never snap themselves — they only threaten via sharp crossings.
	return CONFIG.critical_threshold + 0.02

func _on_cut_down() -> void:
	set_physics_process(false)
	var tw := create_tween()
	tw.set_parallel(true)
	tw.tween_property(self, "global_position",
		global_position + Vector2(randf_range(-40, 40), 220), 0.9)
	tw.tween_property(self, "rotation", rotation + randf_range(-3, 3), 0.9)
	tw.tween_property(self, "modulate:a", 0.0, 0.9)
	tw.chain().tween_callback(queue_free)
	if is_instance_valid(ribbon):
		ribbon.queue_free()
	died.emit("cut")
