extends Button

func _ready():
	# 使用 Callable 对象来连接信号
	self.connect("pressed", Callable(self, "_on_ExitButton_pressed"))

func _on_ExitButton_pressed():
	# 退出游戏
	get_tree().quit()
