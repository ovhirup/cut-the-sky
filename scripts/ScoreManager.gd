class_name ScoreManager
extends Node

signal changed(score: int, combo: int, multiplier: int)

const BASE_CUT := 100
const COMBO_WINDOW := 3.0
const MAX_MULTIPLIER := 8

var score := 0
var combo := 0
var best_combo := 0
var _combo_timer := 0.0

func _process(delta: float) -> void:
	if _combo_timer > 0.0:
		_combo_timer -= delta
		if _combo_timer <= 0.0:
			combo = 0
			changed.emit(score, combo, multiplier())

func register_cut() -> void:
	combo += 1
	best_combo = maxi(best_combo, combo)
	_combo_timer = COMBO_WINDOW
	score += BASE_CUT * multiplier()
	changed.emit(score, combo, multiplier())

func multiplier() -> int:
	return multiplier_for(combo)

func multiplier_for(c: int) -> int:
	return clampi(1 + c / 3, 1, MAX_MULTIPLIER)
