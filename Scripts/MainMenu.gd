extends Spatial

export var fullscreen_start = false
export var music_start = true

onready var mainControl = $Menu
onready var start = $Menu/VBoxContainer/HBoxContainer1/Start

# Called when the node enters the scene tree for the first time.
func _ready():
	start.grab_focus()
	if fullscreen_start:
		OS.window_fullscreen = true
	if not music_start:
		MusicController.on = false
	if MusicController.on and not MusicController.playing:
		MusicController.play_next()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_pressed("escape"):
		get_tree().quit()

func _on_Start_pressed():
	Stats.level_select = false
	MenuSound.play_click()
	get_tree().change_scene("Levels/Level_1.tscn")

func _on_Levels_pressed():
	Stats.level_select = true
	MenuSound.play_click()
	get_tree().change_scene("LevelSelect.tscn")

func _on_Options_pressed():
	MenuSound.play_click()
	get_tree().change_scene("Options.tscn")

func _on_Controls_pressed():
	MenuSound.play_click()
	get_tree().change_scene("Controls.tscn")

func _on_Credits_pressed():
	MenuSound.play_click()
	get_tree().change_scene("Credits.tscn")

func _on_Quit_pressed():
	Stats.save_to_file()
	MenuSound.play_click()
	get_tree().quit()

