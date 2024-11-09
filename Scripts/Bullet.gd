# Bullet.gd
extends Area2D

@export var speed = -300  # 子弹速度

func _process(delta):
	position.x += speed * delta  # 子弹沿X轴正方向移动（向右）

	# 确保子弹在屏幕范围内移动
	if position.x > get_viewport().size.x:
		queue_free()  # 移除超出屏幕的子弹
