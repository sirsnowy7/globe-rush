extends Button

export var LEVEL = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _pressed():
	MenuSound.play_click()
	get_tree().change_scene("Levels/Level_" + str(LEVEL) + ".tscn")
