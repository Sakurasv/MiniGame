# Peashooter.gd
extends Node2D
@export var shootSpeed := 1.0
@onready var mark_2d = $BulletSpawn
@onready var shoot_speed_timer = $shootSpeedTimer

###
@export var bullet_scene: PackedScene  # 预加载子弹场景
@export var fire_rate = 0.48  # 发射子弹的间隔时间（秒）
@onready var timer = Timer.new()  # 创建一个新的计时器
@onready var bullet_spawn_point = $BulletSpawn


const BULLET = preload("res://Prefab/bullet.tscn")
var canShoot = true
var bulletDirection = Vector2(1,0)


func _ready() :
	shoot_speed_timer.wait_time = 1.0 / shootSpeed
	
	### 添加计时器节点到当前节点
	add_child(timer)
	## 配置计时器
	timer.wait_time = fire_rate
	timer.autostart = true
	timer.one_shot = false
	timer.start()
	## 连接计时器的 timeout 信号到生成子弹的方法
	timer.timeout.connect(_on_Timer_timeout)
	

func shoot() :
	if canShoot :
		canShoot = false
		shoot_speed_timer.start()
		
		var bulletNode = BULLET.instantiate()
		
		bulletNode.set_direction(bulletDirection)
		get_tree().root.add_child(bulletNode)
		bulletNode.global_position = mark_2d.global_position

func _on_shoot_speed_timer_timeout():
	canShoot = true
	
func setup_direction(direction) :
	bulletDirection = direction
	
	if direction.x > 0 :
		scale.x = 1
		rotation_degrees = 0
	elif direction.x < 0 :
		scale.x = -1
		rotation_degrees = 0
	elif direction.y < 0 :
		scale.x = 1
		rotation_degrees = -90
	elif direction.y > 0 :
		scale.x = 1
		rotation_degrees = 90









#@export var bullet_scene: PackedScene  # 预加载子弹场景
#@export var fire_rate = 0.48  # 发射子弹的间隔时间（秒）
#
#@onready var timer = Timer.new()  # 创建一个新的计时器
#@onready var bullet_spawn_point = $BulletSpawn  # 获取 BulletSpawn 子节点
#
#func _ready():
	## 添加计时器节点到当前节点
	#add_child(timer)
	## 配置计时器
	#timer.wait_time = fire_rate
	#timer.autostart = true
	#timer.one_shot = false
	#timer.start()
	## 连接计时器的 timeout 信号到生成子弹的方法
	#timer.timeout.connect(_on_Timer_timeout)
#
## 定时器超时回调函数
func _on_Timer_timeout():
	shoot()
	## 实例化子弹
	#var bullet = bullet_scene.instantiate()
	## 设置子弹初始位置为 BulletS pawn 点的位置
	#bullet.position = bullet_spawn_point.global_position
	## 添加子弹到当前场景的根节点
	#get_tree().root.add_child(bullet)



