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

const BULLET = preload("res://Prefab/sadbullet.tscn")
var canShoot = true
var bulletDirection = Vector2(1, 0)

@onready var bullet_spawns = [
	$BulletSpawn1,
	$BulletSpawn2,
	$BulletSpawn3,
	$BulletSpawn4,
	$BulletSpawn5
]

var directions = [
	Vector2(1, 0).normalized(),  # 右上
	Vector2(1, 0.5),  # 右
	Vector2(0, 1),  # 上
	Vector2(-1, 1).normalized(),  # 左上
	Vector2(-1, 0)  # 左
]


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

func shoot(spawn_point, direction):
	var bulletNode = BULLET.instantiate()
	bulletNode.set_direction(direction)
	get_tree().root.add_child(bulletNode)
	bulletNode.global_position = spawn_point.global_position

func _on_shoot_speed_timer_timeout():
	canShoot = true

func shoot_in_all_directions():
	for i in range(bullet_spawns.size()):
		var spawn_point = bullet_spawns[i]
		var direction = directions[i]
		shoot(spawn_point, direction)

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
	if canShoot:
		canShoot = false
		shoot_in_all_directions()
		shoot_speed_timer.start()

func _on_hurt_box_area_entered(area):
	currenthealth -= 40
	emit_signal("healthChange")  # 发出信号通知血条更新
	if currenthealth <= 0:
		die()

func die():
	queue_free()  # 销毁当前节点，从场景中移除角色
