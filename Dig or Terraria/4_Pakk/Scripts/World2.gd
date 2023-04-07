extends Node2D

# Определяем размер карты и количество блоков в каждом ряду и столбце
var map_width = 400
var map_height = 100

# Создаем массив блоков карты и заполняем его случайными блоками
var map = []

var x:int
var y:int

func _ready():

	for x in range(map_width):
		map.append([])
		for y in range(map_height):
			map[x].append(0)

# Заполняем блоками земли поверхность карты
	for x in range(map_width):
		for y in range(30, map_height):
			map[x][y] = 1

# Размещаем водоемы на карте
	for i in range(5):
		x = randi() % map_width
		y = randi() % 40 + 30
		for j in range(20):
			for k in range(20):
				if x+j < map_width and y+k < map_height:
					map[x+j][y+k] = 2

# Размещаем деревья на карте
	for i in range(100):
		x = randi() % map_width
		y = randi() % 70 + 30
		if map[x][y] == 1:
			map[x][y] = 3
			map[x][y-1] = 3
			map[x-1][y-1] = 3
			map[x+1][y-1] = 3
			map[x][y-2] = 3

# Размещаем камни и руды под землей
	for i in range(1000):
		x = randi() % map_width
		y = randi() % 70 + 30
		if map[x][y] == 1:
			map[x][y] = 4
		elif map[x][y] == 4:
			map[x][y] = 5


	# Создаем тайлы для каждого блока на карте
	for x in range(map_width):
		for y in range(map_height):
			if map[x][y] == 1:
				$ground.set_cell(x, y, 3) # земля
			elif map[x][y] == 2:
				$ground.set_cell(x, y, 6) # вода
			elif map[x][y] == 3:
				$ground.set_cell(x, y, 2) # дерево
			elif map[x][y] == 4:
				$ground.set_cell(x, y, 13) # камень
			elif map[x][y] == 5:
				$ground.set_cell(x, y, 14) # руда
	
	$ground.update_bitmask_region(Vector2(0.0,0.0), Vector2(map_width, map_height))
	
	update()
