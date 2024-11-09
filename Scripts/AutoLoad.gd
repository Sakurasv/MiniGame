extends Node

var A_Basic_Timer := 0
var A_timer: Timer

func _ready() -> void:
	A_timer = Timer.new()
	A_timer.wait_time = 480 / 1000.0
	A_timer.one_shot = false
	add_child(A_timer)
	A_timer.timeout.connect(_increment_counter)
	A_timer.start()

func _physics_process(_delta: float) -> void:
	print("A_Basic_Timer: ", A_Basic_Timer)

func _increment_counter() -> void:
	A_Basic_Timer += 480
