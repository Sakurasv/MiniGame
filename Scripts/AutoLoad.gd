extends Node


@export var bgm_path: String = "res://Audio/bgm (mp3cut.net).wav"
var A_Basic_Timer := 0
var A_timer: Timer
var isMushroomAlive := true
var endBGM = false

var bgm_player: AudioStreamPlayer = AudioStreamPlayer.new()


func _ready() -> void:
	A_timer = Timer.new()
	A_timer.wait_time = 480 / 1000.0
	A_timer.one_shot = false
	add_child(A_timer)
	A_timer.timeout.connect(_increment_counter)
	A_timer.start()
	
	bgm_player.stream = load(bgm_path)
	bgm_player.autoplay = true
	#if bgm_player.stream is AudioStream:
		#bgm_player.stream.loop = true  # 直接设置 AudioStream 的 loop 属性
	add_child(bgm_player)
	bgm_player.play()
	
	get_tree().connect("current_scene_changed", Callable(self, "_on_scene_changed"))


func play_bgm():
	bgm_player.play()

func stop_bgm():
	bgm_player.stop()
	
func _on_scene_changed():
	var current_scene = get_tree().current_scene
	if current_scene and current_scene.name == "EndScene":
		print("11111111111111111111111111111111111111111111111111")
		stop_bgm()
	else:
		play_bgm()  # 如果你希望在其他场景中继续播放，可以保留这行
	
func _physics_process(_delta: float) -> void:
	print("A_Basic_Timer: ", A_Basic_Timer)
	if endBGM == true :
		stop_bgm()


func _increment_counter() -> void:
	A_Basic_Timer += 480
