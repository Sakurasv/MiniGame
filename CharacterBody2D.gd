extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var camera = $Camera2D

@export var run_speed: float = 300.0
@export var jump_force: float = -600.0
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.2  # 冲刺持续时间，单位：秒

var can_double_jump: bool = true
var is_dashing: bool = false
var dash_timer: Timer
var skill_timers = {}
var original_scale: Vector2
var current_time: int = 0

func _ready():
	# 初始化冲刺计时器
	dash_timer = Timer.new()
	dash_timer.wait_time = dash_duration
	dash_timer.one_shot = true
	dash_timer.connect("timeout", Callable(self, "_on_dash_timeout"))
	add_child(dash_timer)
	
	# 保存原始缩放比例
	original_scale = sprite.scale
	
	# 初始化技能计时器
	for skill in ["left_click", "right_click", "stretch_x", "stretch_y"]:
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 0.2  # 技能效果持续时间
		add_child(timer)
		timer.connect("timeout", Callable(self, "_on_skill_timeout").bind(skill))
		skill_timers[skill] = timer

func _physics_process(_delta: float):
	current_time = Time.get_ticks_msec()
	if is_dashing:
		# 如果正在冲刺，忽略其他输入，保持冲刺方向和速度
		velocity.x = -dash_speed if sprite.flip_h else dash_speed
	else:
		handle_input()
		apply_gravity()
	move_and_slide()

func handle_input():
	var direction = 0.0
	
	# 处理移动输入
	if Input.is_action_pressed("input_left"):
		direction = -1.0
		sprite.flip_h = true
	elif Input.is_action_pressed("input_right"):
		direction = 1.0
		sprite.flip_h = false

	if is_on_floor():
		can_double_jump = true
		if Input.is_action_just_pressed("input_jump"):
			start_jump()
		elif direction != 0:
			run_state(direction)
		else:
			idle_state()
	else:
		if Input.is_action_just_pressed("input_jump") and can_double_jump:
			start_double_jump()
		else:
			jump_state()

	# 处理冲刺
	if Input.is_action_just_pressed("input_dash"):
		start_dash()

	# 处理技能按键，不使用引擎内置按键映射
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if abs(current_time - Counter.A_Basic_Timer) <= 1500:
			if not skill_timers["left_click"].is_stopped():
				return
			activate_skill("left_click", Vector2(1.2, 1.2))  # 鼠标左键
			camera.start_shake(0.3,5)
		else:
			return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if not skill_timers["right_click"].is_stopped():
			return
		activate_skill("right_click", Vector2(0.8, 0.8))  # 鼠标右键
	if Input.is_key_pressed(KEY_F):
		if not skill_timers["stretch_x"].is_stopped():
			return
		activate_skill("stretch_x", Vector2(1.2, sprite.scale.y))  # F键
	if Input.is_key_pressed(KEY_E):
		if not skill_timers["stretch_y"].is_stopped():
			return
		activate_skill("stretch_y", Vector2(sprite.scale.x, 1.2))  # E键

func idle_state():
	velocity.x = 0

func run_state(direction: float):
	velocity.x = direction * run_speed

func start_jump():
	velocity.y = jump_force

func start_double_jump():
	velocity.y = jump_force
	can_double_jump = false

func jump_state():
	pass

func apply_gravity():
	if not is_on_floor():
		velocity.y += gravity * get_physics_process_delta_time()

func start_dash():
	is_dashing = true
	dash_timer.start()

func _on_dash_timeout():
	is_dashing = false

# 处理技能激活
func activate_skill(skill_name: String, new_scale: Vector2):
	sprite.scale = new_scale
	skill_timers[skill_name].start()

# 技能计时器超时处理
func _on_skill_timeout(_skill_name: String):
	sprite.scale = original_scale

# 记录按键瞬间的时间戳用于调试
func _input(event):
	if event is InputEventKey and event.pressed:
		current_time = Time.get_ticks_msec()
		if event.keycode == KEY_E:
			print("E pressed at: " + str(current_time))
		elif event.keycode == KEY_F:
			print("F pressed at: " + str(current_time))

	if event is InputEventMouseButton and event.pressed:
		current_time = Time.get_ticks_msec()
		print("Mouse button pressed at: " + str(current_time))
