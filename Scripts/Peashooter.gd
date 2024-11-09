# Peashooter.gd
extends Node2D

@export var bullet_scene: PackedScene  # 预加载子弹场景
@export var fire_rate = 0.48  # 发射子弹的间隔时间（秒）

@onready var timer = Timer.new()  # 创建一个新的计时器
@onready var bullet_spawn_point = $BulletSpawn  # 获取 BulletSpawn 子节点

func _ready():
	# 添加计时器节点到当前节点
	add_child(timer)
	# 配置计时器
	timer.wait_time = fire_rate
	timer.autostart = true
	timer.one_shot = false
	timer.start()
	# 连接计时器的 timeout 信号到生成子弹的方法
	timer.timeout.connect(_on_Timer_timeout)

# 定时器超时回调函数
func _on_Timer_timeout():
	# 实例化子弹
	var bullet = bullet_scene.instantiate()
	# 设置子弹初始位置为 BulletSpawn 点的位置
	bullet.position = bullet_spawn_point.global_position
	# 添加子弹到当前场景的根节点
	get_tree().root.add_child(bullet)
