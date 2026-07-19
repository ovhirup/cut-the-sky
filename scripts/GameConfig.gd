class_name GameConfig
extends Resource

@export_group("Steering")
@export var spring_stiffness := 7.0
@export var velocity_damping := 3.2
@export var max_speed := 900.0
@export var accel_max_loose := 1800.0
@export var accel_max_tight := 4200.0
@export var grip_lerp_speed := 8.0

@export_group("Tension")
@export var tension_hold_rate := 0.55
@export var tension_release_rate := 0.75
@export var sharp_threshold := 0.35
@export var critical_threshold := 0.82
@export var min_cut_angle_deg := 35.0

@export_group("Ribbon")
@export var ribbon_sample_hz := 20.0
@export var ribbon_history_sec := 2.75
@export var ribbon_width := 6.0

@export_group("Wind")
@export var wind_strength := 260.0
@export var wind_gust_strength := 340.0
@export var wind_loose_multiplier := 1.0
@export var wind_tight_multiplier := 0.35
