extends AudioStreamPlayer

var on := true
var queue = []
const SOUNDTRACK_FULL = [
	["res://Resources/Sound/Soundtrack/alive.mp3", "I need to do it, to be alive - Soft and Furious"],
	["res://Resources/Sound/Soundtrack/warming.mp3", "Warming up - Soft and Furious"],
	["res://Resources/Sound/Soundtrack/seeming.mp3", "see me seeming - Soft and Furious"],
	["res://Resources/Sound/Soundtrack/idea.mp3", "idea - Vandalorum"],
	["res://Resources/Sound/Soundtrack/solitude.mp3", "Solitude - Vandalorum"]
]

onready var track_disp = $"Track Display"
onready var track_label = $"Track Display/Track Label"
onready var timer = $"Timer"

func _ready():
	new_shuffle()

func _process(delta):
	if timer.is_stopped() and track_disp.margin_left > -1000:
		track_disp.margin_left -= -1 * (0.05*track_disp.margin_left)
		

func new_shuffle():
	# create queue list and shuffle keeping first song in place
	queue = SOUNDTRACK_FULL.duplicate()
	var first = queue.pop_front()
	queue.shuffle()
	queue.push_front(first)

func play_next():
	# display
	track_label.text = queue[0][1]
	track_disp.margin_left = -1
	timer.start(3)
	# stream
	stream = load(queue[0][0])
	play()
	queue.pop_front()

func _on_MusicController_finished():
	if on:
		if queue.size() == 0:
			new_shuffle()
			play_next()
		else:
			play_next()
