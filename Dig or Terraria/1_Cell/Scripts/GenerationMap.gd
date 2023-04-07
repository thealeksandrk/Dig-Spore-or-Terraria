extends Node2D

export var width:int
export var height:int

export var _seed:String
export var useRandomSeed:bool
export(int,0,100) var RandomFillPercent

var map:Array
var tile_type:int


func _ready():
	generate()
	_drawMap()
	update()

func _process(delta):
	if Input.is_mouse_button_pressed(1):
		generate()
		_drawMap()
		update()

func generate():
	RandomFillMap()
	for i in range(2):
		SmoothMap()
	

func SmoothMap():
	for x in range(1, width):
		for y in range(1, height):
			var NumWall=CounterWall(x,y)
			
			if map[x][y]==1:
				if NumWall>=4:
					map[x][y]=1
				if NumWall<3:
					map[x][y]=0
			elif NumWall>=5:
				map[x][y]=1

func CounterWall(x,y):
	var wallCount=0
	for xi in range(x-1, x+2):
		for yi in range(y-1, y+2):
			if x!=xi or y!=yi:
				if isWall(xi,yi):
					wallCount+=1
	return wallCount

func isWall(x,y):
	if isBound(x,y) or map[x][y]==1:
		return true
	elif map[x][y]==0:
		return false

func isBound(x,y):
	if x<1 or y<1:
		return true
	elif x>width-2 or y>height-2:
		return true


func RandomFillMap():
	if useRandomSeed:
		_seed=str(OS.get_system_time_msecs())
	var pseudoRandom:RandomNumberGenerator=RandomNumberGenerator.new()
	pseudoRandom.seed=_seed.hash()
	map=[]
	for x in range(width+2):
		map.append([])
		for y in range(height+2):
			map[x].append(0)
	for x in range(1, width):
		for y in range(1, height):
			if x==0 or x==width-1 or y==0 or y==height-1:
				map[x][y]=1
			else:
				map[x][y]=1 if RandomFillPercent>=pseudoRandom.randi()%100 else 0


func _drawMap():
	if map.size()>0:
		_redact_cells()
		_redact_cells()
		for x in range(width):
			for y in range(height):
				$water_world.set_cell(x,y,map[x][y]-1)

	$water_world.update_bitmask_region(Vector2(0.0,0.0), Vector2(width, height))

func _redact_cells():
	for x in range(1, width):
		for y in range(1, height):
			# Пройдем по всем тайлам на карте
			# Если тайл пустой, пропускаем его
			if map[x][y] == 0:
				continue
			# Иначе определяем его тип, основываясь на соседних тайлах
			tile_type = 5  # по умолчанию - центральная клетка
			# Сверхy
			if map[x][y-1] >= 1 and map[x][y+1] == 0:
			# Торец или угол
				if map[x-1][y] == 0:
					if map[x+1][y] == 0:
						tile_type = 8  # торец
					else:
						tile_type = 9  # левый угол
				elif map[x+1][y] == 0:
					tile_type = 7  # правый угол
			# Снизу
			elif map[x][y+1] >= 1:
				# Торец или угол
				if map[x-1][y] == 0:
					if map[x+1][y] == 0:
						tile_type = 2  # торец
					else:
						tile_type = 1  # левый угол
				elif map[x+1][y] == 0:
					tile_type = 3  # правый угол
			# Слева
			elif map[x-1][y] >= 1 and map[x+1][y] == 0:
				# Торец или угол
				if map[x][y-1] == 0:
					if map[x][y+1] == 0:
						tile_type = 6  # торец
					else:
						tile_type = 3  # правый угол
				elif map[x][y+1] == 0:
					tile_type = 9  # правый угол
			# Справа
			elif map[x+1][y] >= 1:
				# Торец или угол
				if map[x][y-1] == 0:
					if map[x][y+1] == 0:
						tile_type = 4  # торец
					else:
						tile_type = 1  # левый угол
				elif map[x][y+1] == 0:
					tile_type = 7  # левый угол
	
			# Записываем тип тайла в массив карты
			map[x][y] = tile_type

