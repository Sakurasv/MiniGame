extends ProgressBar

@export var peashooter: CharacterBody2D

func _ready():
	peashooter.healthChange.connect(_on_health_change)
	_on_health_change()  # 确保初始值正确

func _on_health_change():
	value = peashooter.currenthealth * 100 / peashooter.maxhealth
