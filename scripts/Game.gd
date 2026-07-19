extends Node2D

const HIT_STOP := 0.07
const HIT_STOP_SCALE := 0.08

@onready var _kite: PlayerKite = $PlayerKite
@onready var _wind: WindSystem = $WindSystem
@onready var _director: EnemyDirector = $EnemyDirector
@onready var _score: ScoreManager = $ScoreManager
@onready var _fx: Node2D = $CutFX

@onready var _tension_bar: ProgressBar = %TensionBar
@onready var _state_label: Label = %StateLabel
@onready var _score_label: Label = %ScoreLabel
@onready var _combo_label: Label = %ComboLabel
@onready var _over_panel: Control = %OverPanel
@onready var _over_text: Label = %OverText

var _cutter := CutResolver.new()
var _run_seed := 0
var _survival := 0.0
var _over := false

func _ready() -> void:
	_run_seed = int(Time.get_unix_time_from_system()) & 0x7fffffff
	seed(_run_seed)
	_kite.wind = _wind
	_kite.died.connect(_on_player_died)
	_score.changed.connect(_on_score_changed)
	_director.configure(self, _wind, _kite, _run_seed)
	_director.start()
	_over_panel.visible = false
	_on_score_changed(0, 0, 1)

func _physics_process(delta: float) -> void:
	if _over:
		return
	_survival += delta
	var outcome := _cutter.resolve(_kite, _director.enemies)
	if outcome.enemy_cut:
		outcome.enemy_cut.die_cut()
		_score.register_cut()
		_do_cut_feedback(outcome.point)
	elif outcome.player_cut:
		_kite.die_cut()

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

func _do_cut_feedback(point: Vector2) -> void:
	var flash := Sprite2D.new()
	# lightweight burst: a scaling, fading white dot standing in for fragments
	var img := Image.create(8, 8, false, Image.FORMAT_RGBA8)
	img.fill(Color.WHITE)
	flash.texture = ImageTexture.create_from_image(img)
	flash.global_position = point
	flash.scale = Vector2.ONE * 2.0
	_fx.add_child(flash)
	var tw := create_tween()
	tw.set_parallel(true)
	tw.tween_property(flash, "scale", Vector2.ONE * 9.0, 0.3)
	tw.tween_property(flash, "modulate:a", 0.0, 0.3)
	tw.chain().tween_callback(flash.queue_free)
	_hit_stop()

func _hit_stop() -> void:
	Engine.time_scale = HIT_STOP_SCALE
	await get_tree().create_timer(HIT_STOP * HIT_STOP_SCALE, true, true).timeout
	Engine.time_scale = 1.0

func _on_score_changed(score: int, combo: int, mult: int) -> void:
	_score_label.text = "%d" % score
	_combo_label.text = ("x%d  (%d cut)" % [mult, combo]) if combo > 0 else ""

func _on_player_died(reason: String) -> void:
	if _over:
		return
	_over = true
	Engine.time_scale = 1.0
	await get_tree().create_timer(0.6).timeout
	var why := "YOUR LINE SNAPPED" if reason == "snapped" else "YOUR KITE WAS CUT"
	_over_text.text = "%s\n\nScore  %d\nBest combo  x%d\nSurvived  %.1fs\nSeed  %d\n\npress R" % [
		why, _score.score, _score.multiplier_for(_score.best_combo),
		_survival, _run_seed]
	_over_panel.visible = true
