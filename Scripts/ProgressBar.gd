extends TextureProgressBar

@export var player :CharacterBody2D

func  _ready():
	player.healthChange.connect(update)
	update()


func update():
	value = player.currenthealth * 100 / player.maxhealth
