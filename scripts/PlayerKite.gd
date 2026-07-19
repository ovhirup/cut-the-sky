class_name PlayerKite
extends Kite

signal line_snapped

func _desired_position() -> Vector2:
	return get_global_mouse_position()

func _wants_tighten() -> bool:
	return Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) \
		or Input.is_key_pressed(KEY_SPACE)

func _on_snap() -> void:
	alive = false
	modulate = Color(1.0, 1.0, 1.0, 0.35)
	ribbon.set_ribbon_state(2)
	line_snapped.emit()
	died.emit("snapped")

func _on_cut_down() -> void:
	modulate = Color(1.0, 1.0, 1.0, 0.35)
	died.emit("cut")
