extends Control


onready var label : Label = find_node("Label")
onready var no_threat_button : CheckButton = find_node("CheckButtonNoThreat")
onready var left_right_button : CheckButton = find_node("CheckButtonLeftRight")
onready var start_button : Button = find_node("ButtonStart")
onready var scroll_container : ScrollContainer = find_node("ScrollContainer")


var _no_threat := true
var _left_right := false
var _running := false

var _active_threat := false
var _threat_time := 0.0
var _current_time := 0.0

var audio_stream_player : AudioStreamPlayer
var random : RandomNumberGenerator



func _ready() -> void:
	audio_stream_player = AudioStreamPlayer.new()
	random = RandomNumberGenerator.new()
	add_child(audio_stream_player)


func _on_CheckButtonNoThreat_toggled(button_pressed: bool) -> void:
	_no_threat = button_pressed


func _on_CheckButtonLeftRight_toggled(button_pressed: bool) -> void:
	_left_right = button_pressed


func _on_ButtonStart_pressed() -> void:
	_running = !_running
	start_button.text = "STOP" if _running else "START"
	_threat_time = random.randf_range(1.0, 3.0)


func _process(_delta: float) -> void:
	
	if not _running:
		return

	_current_time += _delta
	_check_sound()


func _check_sound() -> void:
	if _current_time > _threat_time:
		if not _active_threat:
			if _left_right:
				var target = choice(["left", "right", "front"])
				play_sound("threat_" + target)
			else:
				play_sound("threat")
			_active_threat = true
			_threat_time = random.randf_range(1.0, 5.0)
		else:
			if not _no_threat or randf() > 0.5:
				play_sound("gun")
			else:
				play_sound("no_threat")
			_active_threat = false
			_threat_time = random.randf_range(2.0, 6.0)
		_current_time = 0.0


func play_sound(sound_name: String) -> void:
	var sound = load("res://sounds/" + sound_name + ".mp3")
	audio_stream_player.stream = sound
	audio_stream_player.play()


func choice(choices: Array) -> String:
	return choices[randi() % choices.size()]
