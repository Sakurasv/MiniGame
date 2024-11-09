extends Sprite2D

var current_time := 0
var last_visibility_change := 0
var visible_duration := 20  # visible 状态持续的时间，单位毫秒
var invisible_duration := 480  # invisible 状态持续的时间，单位毫秒

func _ready():
	# 初始化时让 Sprite2D 不可见
	self.visible = false

func _physics_process(_delta: float) -> void:
	current_time = Time.get_ticks_msec()
	var time_since_last_change := current_time - last_visibility_change

	if self.visible:
		# 如果当前可见，并且已经可见了超过20ms，那么就变为不可见
		if time_since_last_change >= visible_duration:
			self.visible = false
			last_visibility_change = current_time
	else:
		# 如果当前不可见，并且已经不可见了超过480ms，那么就变为可见
		if time_since_last_change >= invisible_duration:
			self.visible = true
			last_visibility_change = current_time
