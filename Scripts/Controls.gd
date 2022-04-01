extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_pressed("escape"):
		get_tree().change_scene("res://MainMenu.tscn")

func _on_Menu_pressed():
	MenuSound.play_click()
	get_tree().change_scene("MainMenu.tscn")
