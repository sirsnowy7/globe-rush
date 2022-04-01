extends PanelContainer

onready var returnButton = $MarginContainer/VBoxContainer/HBoxContainer/Return
onready var clearButton = $MarginContainer/VBoxContainer/HBoxContainer/Clear

func _ready():
	returnButton.grab_focus()

func _on_Return_pressed():
	MenuSound.play_click()
	get_tree().paused = false
	get_parent().get_node("VBoxContainer/Level1/Button").grab_focus()
	queue_free()

func _on_Quit_pressed():
	MenuSound.play_click()
	Stats.clear_file()
	get_tree().paused = false
	get_tree().change_scene("MainMenu.tscn")
