# Portal.gd
extends Area2D

@export var next_scene: String  # 下一关卡的场景路径
@onready var collision_shape = $CollisionShape2D  # 碰撞形状节点


func _ready():
	hide()  # 起初隐藏传送门
	collision_shape.disabled = true  # 禁用碰撞体
	# 使用 Callable 来连接信号
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":  # 确保是玩家进入传送门
		get_tree().change_scene_to_file(next_scene)  # 切换到下一关卡

func _process(delta):
	if Counter.isMushroomAlive == false:
		show()
		collision_shape.disabled = false  # 开启碰撞体
