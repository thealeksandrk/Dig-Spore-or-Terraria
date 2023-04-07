extends Node2D

export var width:int
export var height:int

export var _seed:String
export var useRandomSeed:bool
export(int,0,100) var RandomFillPercent

var map:Array

func _ready():
	generate()
	_drawMap()
	update()

func _process(delta):
	if Input.is_mouse_button_pressed(1):
		generate()
		update()

func generate():
	RandomFillMap()
	for i in range(3):
		SmoothMap()
	

func SmoothMap():
	for x in range(width):
		for y in range(height):
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
	if isBound(x,y):
		return true
	if map[x][y]==1:
		return true
	elif map[x][y]==0:
		return false

func isBound(x,y):
	if x<0 or y<0:
		return true
	elif x>width-1 or y>height-1:
		return true




func RandomFillMap():
	if useRandomSeed:
		_seed=str(OS.get_system_time_msecs())
	var pseudoRandom:RandomNumberGenerator=RandomNumberGenerator.new()
	pseudoRandom.seed=_seed.hash()
	map=[]
	for x in range(width):
		map.append([])
		for y in range(height):
			map[x].append([])
	for x in range(width):
		for y in range(height):
			if x==0 or x==width-1 or y==0 or y==height-1:
				map[x][y]=1
			else:
				map[x][y]=1 if RandomFillPercent>=pseudoRandom.randi()%100 else 0


func _drawMap():
	if map.size()>0:
		for x in range(width):
			for y in range(height):
				$ground.set_cell(x,y,map[x][y]+2)
				
				
	$ground.update_bitmask_region(Vector2(0.0,0.0), Vector2(width, height))
