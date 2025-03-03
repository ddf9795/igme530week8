extends Node

var columnCount = 10;
var rowCount = 10;
var currentCells = [];
var nextCells = [];

var rng = BetterRng.new()

var timer = 0

var firstRun = true

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_R:
			get_tree().change_scene("Title.tscn")

func _ready():
	rng.randomize()
	for column in range(columnCount):
		currentCells.append([])
		for row in range(rowCount):
			currentCells[column].append(0)
	for column in range(columnCount):
		for row in range(rowCount):
			var miniGame = preload("res://MiniLife.tscn").instance()
			currentCells[column][row] = miniGame;
			$GridContainer.add_child(miniGame)
	nextCells = currentCells.duplicate(true)

func _process(delta):
	timer += delta
#	print(timer)
	if timer >= 0.1 and firstRun:
		firstRun = false
		timer = 0
		for column in range(columnCount):
			for row in range(rowCount):
				match int(rng.coin_flip()):
					0:
						currentCells[column][row].kill()
					1:
						currentCells[column][row].revive()
	if timer >= 0.5:
		timer = 0
		generate()

func generate():
	for column in range(columnCount):
		for row in range(rowCount):
			var left = (column - 1 + columnCount) % columnCount
			var right = (column + 1) % columnCount
			var above = (row - 1 + rowCount) % rowCount
			var below = (row + 1) % rowCount
			
			var neighbors = currentCells[left][above].alive + currentCells[column][above].alive + currentCells[right][above].alive + currentCells[left][row].alive + currentCells[right][row].alive + currentCells[left][below].alive + currentCells[column][below].alive + currentCells[right][below].alive
			
			if neighbors < 2 or neighbors > 3:
				nextCells[column][row].kill();
			elif neighbors == 3:
				nextCells[column][row].revive();
			else:
				nextCells[column][row] = currentCells[column][row]
	var temp = currentCells.duplicate(true)
	currentCells = nextCells.duplicate(true)
	nextCells = temp
