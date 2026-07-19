class_name WindSystem
extends Node

const CONFIG := preload("res://resources/GameConfig.tres")

# Deterministic layered sines — RunSeed will offset _t and phases later.
var _t := 0.0

func _physics_process(delta: float) -> void:
	_t += delta

func force_at_time() -> Vector2:
	var base := Vector2(
		sin(_t * 0.31) + 0.6 * sin(_t * 0.77 + 1.7),
		0.35 * sin(_t * 0.53 + 0.9)
	)
	var gust := Vector2(sin(_t * 1.9) * maxf(0.0, sin(_t * 0.13)), 0.0)
	return base * CONFIG.wind_strength + gust * CONFIG.wind_gust_strength
