extends Node2D

@onready var _kite: PlayerKite = $PlayerKite
@onready var _wind: WindSystem = $WindSystem
@onready var _tension_bar: ProgressBar = %TensionBar
@onready var _state_label: Label = %StateLabel
@onready var _snap_label: Label = %SnapLabel

func _ready() -> void:
	_kite.wind = _wind
	_kite.line_snapped.connect(_on_line_snapped)
	_snap_label.visible = false

func _process(_delta: float) -> void:
	_tension_bar.value = _kite.tension
	match _kite.state():
		0: _state_label.text = "LOOSE"
		1: _state_label.text = "SHARP"
		2: _state_label.text = "CRITICAL"

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			get_tree().reload_current_scene()

func _on_line_snapped() -> void:
	_snap_label.visible = true
