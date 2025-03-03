extends ColorRect

var columnCount = 5;
var rowCount = 5;
var alive = 0;
var currentCells = [];
var nextCells = [];

var _seed = 0

var rng = BetterRng.new()

var timer = 0

func _init():
	rng.randomize()
	for column in range(columnCount):
		currentCells.append([])
		for row in range(rowCount):
			currentCells[column].append(0)
	nextCells = currentCells.duplicate(true)

func _process(delta):
	update()
	timer += delta
	if timer > 0.5:
		timer = 0
		generate()


func generate():
	if not alive: return
	for column in range(columnCount):
		for row in range(rowCount):
			var left = (column - 1 + columnCount) % columnCount
			var right = (column + 1) % columnCount
			var above = (row - 1 + rowCount) % rowCount
			var below = (row + 1) % rowCount
			
			var neighbors = currentCells[left][above] + currentCells[column][above] + currentCells[right][above] + currentCells[left][row] + currentCells[right][row] + currentCells[left][below] + currentCells[column][below] + currentCells[right][below]
			
			if neighbors < 2 or neighbors > 3:
				nextCells[column][row] = 0;
			elif neighbors == 3:
				nextCells[column][row] = 1;
			else:
				nextCells[column][row] = currentCells[column][row]
	var temp = currentCells.duplicate(true)
	currentCells = nextCells.duplicate(true)
	nextCells = temp
	alive = int(isAlive())
	
func isAlive():
	var liveCount = 0
	var totalCount = 0
	for column in range(columnCount):
		for row in range(rowCount):
			totalCount += 1
			liveCount += currentCells[column][row]
	return (liveCount > (totalCount / 10))
	
func kill():
	alive = 0
#	for column in range(columnCount):
#		for row in range(rowCount):
#			currentCells[column][row] = 0
#	nextCells = currentCells.duplicate(true)

func revive():
#	print("reviving")
	alive = 1
	if not isAlive():
		var liveCount = 1
		var totalCount = 2
		var firstIteration = true
	#	while !((liveCount) > (totalCount / 2)):
	#		if firstIteration:
	#			liveCount -= 1
	#			totalCount -= 2
	#			firstIteration = false
	#		for column in range(columnCount):
	#			for row in range(rowCount):
	#				var rand = int(rng.coin_flip())
	##				print(rand)
	#				liveCount += rand
	#				totalCount += 1
	#				currentCells[column][row] = rand
		if firstIteration:
			liveCount -= 1
			totalCount -= 2
			firstIteration = false
		for column in range(columnCount):
			for row in range(rowCount):
				var rand = int(rng.coin_flip())
	#				print(rand)
				liveCount += rand
				totalCount += 1
				currentCells[column][row] = rand
		nextCells = currentCells.duplicate(true)

func _draw():
#	if not isAlive(): return;
	var col = Color.black if alive else Color.darkgray
	for column in range(columnCount):
		for row in range(rowCount):
			if currentCells[column][row] == 1:
				draw_rect(Rect2(column * 20, row * 20, 20, 20), col)
