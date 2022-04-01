extends Control

onready var text = $RichTextLabel
var running = false;

func _ready():
	$Menu.grab_focus()

func _process(delta):
	if running:
		text.margin_top -= 1

func _input(event):
	if event.is_action_pressed("escape"):
		get_tree().change_scene("res://MainMenu.tscn")

func _on_Menu_pressed():
	MenuSound.play_click()
	get_tree().change_scene("MainMenu.tscn")

func _on_Timer_timeout():
	running = true
