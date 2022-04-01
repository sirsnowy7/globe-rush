extends Control

onready var button = $VBoxContainer/Level1/Button

onready var levels = [
	$VBoxContainer/Level1,
	$VBoxContainer/Level2,
	$VBoxContainer/Level3,
	$VBoxContainer/Level4,
	$VBoxContainer/Level5
]

var clearModal = load("res://ClearModal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	button.grab_focus()
	for i in range(3):
		var timeLabel = levels[i].get_node("Time")
		var playerTime = Stats.level_stats[i][0]
		var parTime = Stats.max_stats[i][0]
		
		var scoreLabel = levels[i].get_node("Score")
		var playerScore = Stats.level_stats[i][1]
		var parScore = Stats.max_stats[i][1]
		
		var rankLabel = levels[i].get_node("Rank")
		var points = 0
		
		if playerTime < 0:
			timeLabel.text = "-/" + str(parTime) + ".0"
		else:
			timeLabel.text = str(playerTime) + "/" + str(parTime) + ".0"
			
		if playerScore < 0:
			scoreLabel.text = "-/" + str(parScore)
		else:
			scoreLabel.text = str(playerScore) + "/" + str(parScore)
		
		if playerScore >= parScore:
			points += 1
		if playerTime > 0:
			points += 1
			if playerTime <= parTime:
				points += 1
		
		if points <= 0:
			rankLabel.text = "-"
		elif points == 1:
			rankLabel.text = "B"
		elif points == 2:
			rankLabel.text = "A"
		elif points == 3:
			rankLabel.text = "S"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Menu_pressed():
	MenuSound.play_click()
	get_tree().change_scene("MainMenu.tscn")

func _input(event):
	if event.is_action_pressed("escape"):
		get_tree().change_scene("res://MainMenu.tscn")

func _on_Clear_pressed():
	add_child(clearModal.instance())
	get_tree().paused = true
