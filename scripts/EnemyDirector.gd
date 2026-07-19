class_name EnemyDirector
extends Node

signal enemy_spawned(enemy: EnemyKite)

const ENEMY_SCENE := preload("res://scenes/EnemyKite.tscn")
const MAX_ENEMIES := 5
const FIRST_DELAY := 12.0
const RAMP_INTERVAL := 17.0

const PALETTES := [
	Color(0.20, 0.55, 0.90), Color(0.35, 0.75, 0.45),
	Color(0.85, 0.30, 0.55), Color(0.60, 0.40, 0.85),
	Color(0.95, 0.80, 0.25),
]

var wind: WindSystem
var target: Node2D
var _spawn_root: Node
var _t := 0.0
var _spawned := 0
var _next_spawn := 0.0
var _rng := RandomNumberGenerator.new()
var enemies: Array[EnemyKite] = []

func configure(spawn_root: Node, w: WindSystem, tgt: Node2D, run_seed: int) -> void:
	_spawn_root = spawn_root
	wind = w
	target = tgt
	_rng.seed = run_seed

func start() -> void:
	_spawn()               # one enemy immediately for the 5-second-action rule
	_next_spawn = FIRST_DELAY

func _physics_process(delta: float) -> void:
	_t += delta
	enemies = enemies.filter(func(e): return is_instance_valid(e) and e.alive)
	if _spawned < MAX_ENEMIES and _t >= _next_spawn:
		_spawn()
		_next_spawn = _t + RAMP_INTERVAL

func _spawn() -> void:
	var e: EnemyKite = ENEMY_SCENE.instantiate()
	var ramp := float(_spawned) / float(MAX_ENEMIES)
	e.wind = wind
	e.preferred_altitude = _rng.randf_range(0.22, 0.6)
	e.oscillation_rate = _rng.randf_range(0.4, 0.9)
	e.oscillation_width = _rng.randf_range(200.0, 340.0)
	e.aggression = 0.35 + ramp * 0.5 + _rng.randf_range(-0.05, 0.05)
	e.tighten_rhythm = 0.28 + ramp * 0.18
	e.rhythm_rate = _rng.randf_range(0.55, 0.95)
	var r := get_viewport().get_visible_rect()
	e.position = Vector2(_rng.randf_range(r.size.x * 0.2, r.size.x * 0.8),
		r.size.y * e.preferred_altitude)
	e.modulate = PALETTES[_spawned % PALETTES.size()]
	_spawn_root.add_child(e)
	e.setup(target, _rng.randf_range(0.0, TAU))
	enemies.append(e)
	_spawned += 1
	enemy_spawned.emit(e)
