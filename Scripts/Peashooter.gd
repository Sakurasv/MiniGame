extends CharacterBody2D

signal healthChange  # 信号定义

@export var shootSpeed := 0.96
@onready var mark_2d = $BulletSpawn
@onready var shoot_speed_timer = $shootSpeedTimer

@export var bullet_scene: PackedScene # 预加载子弹场景
@export var fire_rate = 0.96 # 发射子弹的间隔时间（秒）
@onready var timer = Timer.new() # 创建一个新的计时器
@onready var bullet_spawn_point = $BulletSpawn
@export var maxhealth :int = 400
@onready var currenthealth :int = maxhealth
@onready var animated2d := $AnimatedSprite2D

const BULLET = preload("res://Prefab/bullet.tscn")
var canShoot = true
var bulletDirection = Vector2(1, 0)

func _ready():
	shoot_speed_timer.wait_time = 1.0 / shootSpeed
	add_child(timer)
	timer.wait_time = fire_rate
	timer.autostart = true
	timer.one_shot = false
	timer.start()
	timer.timeout.connect(_on_Timer_timeout)
	animated2d.play("default")
	

	emit_signal("healthChange")  # 确保初始值

func shoot():
	if canShoot:
		canShoot = false
		shoot_speed_timer.start()
		var bulletNode = BULLET.instantiate()
		bulletNode.set_direction(bulletDirection)
		get_tree().root.add_child(bulletNode)
		bulletNode.global_position = mark_2d.global_position

func _on_shoot_speed_timer_timeout():
	canShoot = true

func setup_direction(direction):
	bulletDirection = direction
	if direction.x > 0:
		scale.x = 1
		rotation_degrees = 0
	elif direction.x < 0:
		scale.x = -1
		rotation_degrees = 0
	elif direction.y < 0:
		scale.x = 1
		rotation_degrees = -90
	elif direction.y > 0:
		scale.x = 1
		rotation_degrees = 90

func _on_Timer_timeout():
	shoot()

func _on_hurt_box_area_entered(area):
	currenthealth -= 100
	emit_signal("healthChange")  # 发出信号通知血条更新
	if currenthealth <= 0:
		die()

func die():
	Counter.isMushroomAlive = false
	queue_free()  # 销毁当前节点，从场景中移除角色
