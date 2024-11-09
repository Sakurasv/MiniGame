extends Camera2D

@export var shake_duration: float = 0.5
@export var shake_magnitude: float = 10.0

var shaking: bool = false
var shake_time: float = 0.0
var original_position: Vector2

func _ready():
	original_position = position

func _process(delta):
	if shaking:
		if shake_time > 0:
			shake_time -= delta
			position = original_position + Vector2(
				randf_range(-shake_magnitude, shake_magnitude),
				randf_range(-shake_magnitude, shake_magnitude)
			)
		else:
			shaking = false
			position = original_position

func start_shake(duration: float, magnitude: float):
	shake_time = duration
	shake_magnitude = magnitude
	shaking = true
	original_position = position
