extends Node

var level_stats = [
# time, score
	[-1.0, -1],
	[-1.0, -1],
	[-1.0, -1]
]

const NO_STATS = [
# time, score
	[-1.0, -1],
	[-1.0, -1],
	[-1.0, -1]
]

export var max_stats = [
	[10.0, 10],
	[35.0, 8],
	[27.0, 4],
]

var harden := false
var level_select := false
var checkpoint := 0
var prev_time := 0.0

const SAVE_FILE_NAME = "user://save.json"

func _ready():
	load_from_file()

#func _process(delta):
#	pass

func save_to_file():
	var file = File.new()
	file.open(SAVE_FILE_NAME, File.WRITE)
	file.store_string(to_json(level_stats))
	file.close()

func load_from_file():
	var file = File.new()
	if file.file_exists(SAVE_FILE_NAME):
		file.open(SAVE_FILE_NAME, file.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_ARRAY:
			level_stats = data
		else:
			print("Corrupt data")
	else:
		print("No data")

func clear_file():
	var dir = Directory.new()
	dir.remove(SAVE_FILE_NAME)
	print("Save deleted")
	level_stats = NO_STATS.duplicate(true)
