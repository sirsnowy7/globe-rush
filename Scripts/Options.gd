extends Control

onready var fullsc_button = $VBoxContainer/Fullscreen
onready var fun_button = $VBoxContainer/Fun

# Called when the node enters the scene tree for the first time.
func _ready():
	fullsc_button.pressed = OS.window_fullscreen
	fullsc_button.grab_focus()
	fun_button.pressed = Stats.harden

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Fullscreen_toggled(button_pressed):
	MenuSound.play_click()
	OS.window_fullscreen = button_pressed

func _on_Fun_toggled(button_pressed):
	MenuSound.play_click()
	Stats.harden = button_pressed

func _on_Music_pressed():
	MenuSound.play_click()
	if MusicController.playing:
		MusicController.on = false
		MusicController.stop()
	else:
		MusicController.on = true
		MusicController.play()

func _on_Menu_pressed():
	MenuSound.play_click()
	get_tree().change_scene("MainMenu.tscn")

func _input(event):
	if event.is_action_pressed("escape"):
		get_tree().change_scene("res://MainMenu.tscn")
