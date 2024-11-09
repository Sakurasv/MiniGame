extends Sprite2D

@onready var sideframe = $SideFrame


var current_time := 0


func _physics_process(_delta: float) -> void:
	
	current_time = Time.get_ticks_msec()

	if Input.is_action_pressed("input_left"):
		sideframe.visible = false	
	else :
		return
