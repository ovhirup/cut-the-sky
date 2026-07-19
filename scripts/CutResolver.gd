class_name CutResolver
extends Node

const CONFIG := preload("res://resources/GameConfig.tres")

# Checks the newest player segment against each enemy's newest segment.
# A cut needs: cutter ribbon sharp, victim not sharp, real crossing,
# crossing angle above the configured minimum. Returns whoever gets cut.

class Outcome:
	var enemy_cut: Kite
	var player_cut := false
	var point := Vector2.ZERO

func resolve(player: Kite, enemies: Array) -> Outcome:
	var out := Outcome.new()
	if not player.alive:
		return out
	var p_seg := _newest_segment(player.ribbon)
	if p_seg.is_empty():
		return out

	for e in enemies:
		var enemy := e as Kite
		if enemy == null or not enemy.alive:
			continue
		var e_seg := _newest_segment(enemy.ribbon)
		if e_seg.is_empty():
			continue
		var hit = Geometry2D.segment_intersects_segment(
			p_seg[0], p_seg[1], e_seg[0], e_seg[1])
		if hit == null:
			continue
		var angle := _cross_angle(p_seg, e_seg)
		if angle < deg_to_rad(CONFIG.min_cut_angle_deg):
			continue

		var p_sharp := player.state() >= 1
		var e_sharp := enemy.state() >= 1
		if p_sharp and not e_sharp:
			out.enemy_cut = enemy
			out.point = hit
			return out
		if e_sharp and not p_sharp:
			out.player_cut = true
			out.point = hit
			return out
		# Both sharp or both loose at a real crossing: attacker (player
		# holding tighter) wins; ties favour the player for fairness.
		if p_sharp and e_sharp:
			if player.tension >= enemy.tension:
				out.enemy_cut = enemy
			else:
				out.player_cut = true
			out.point = hit
			return out
	return out

func _newest_segment(ribbon: Line2D) -> Array:
	if ribbon == null or ribbon.get_point_count() < 2:
		return []
	var n := ribbon.get_point_count()
	return [ribbon.get_point_position(n - 2), ribbon.get_point_position(n - 1)]

func _cross_angle(a: Array, b: Array) -> float:
	var da: Vector2 = (a[1] - a[0]).normalized()
	var db: Vector2 = (b[1] - b[0]).normalized()
	var dot := clampf(absf(da.dot(db)), 0.0, 1.0)
	return acos(dot)  # 0 = parallel, PI/2 = perpendicular
