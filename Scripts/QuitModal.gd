extends PanelContainer

onready var returnButton = $MarginContainer/VBoxContainer/HBoxContainer/Return
onready var quitButton = $MarginContainer/VBoxContainer/HBoxContainer/Quit

func _ready():
	returnButton.grab_focus()

func _on_Return_pressed():
	MenuSound.play_click()
	get_tree().paused = false
	queue_free()

func _on_Quit_pressed():
	MenuSound.play_click()
	get_tree().paused = false
	get_parent().quit_to_menu()
