extends Button

func _ready():
	# 使用 Callable 对象来连接信号
	self.connect("pressed", Callable(self, "_on_StartButton_pressed"))

func _on_StartButton_pressed():
	# 切换到游戏场景
	get_tree().change_scene_to_file("res://Scene/Level2.tscn")
