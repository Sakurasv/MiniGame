# Bullet.gd
extends Area2D

@export var speed := -300  # 子弹速度
@export var damage := 100

var direction : Vector2

func _ready():
	await get_tree().create_timer(3).timeout
	queue_free()

func set_direction(bulletDirection) :
	direction = bulletDirection
	rotation_degrees = rad_to_deg(global_position.angle_to_point(global_position + direction))
	
func _physics_process(delta):
	global_position += direction * speed * delta
	
		
#func _process(delta):
	#position.x += speed * delta  # 子弹沿X轴正方向移动（向右）
#
# 确保子弹在屏幕范围内移动
	if position.x > get_viewport().size.x:
		queue_free()  # 移除超出屏幕的子弹


#func _on_body_entered(body):
	#body.get_damage(damage)
	#queue_free()


func _on_hit_box_area_entered(_area):
	print("hit")
	if Input.is_key_pressed(KEY_F) :
		direction *= -1
	
