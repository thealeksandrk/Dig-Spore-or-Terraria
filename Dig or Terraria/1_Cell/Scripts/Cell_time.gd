extends Node2D

const MAX_ENEMIES = 20 # максимальное количество противников
const ENEMY_SCENE_PATH = ["res://1_Cell/Scenes/Cell_Enemy_herbivor_0.tscn", 
"res://1_Cell/Scenes/Cell_Enemy_predator_0.tscn"] # путь к файлу сцены противника

var _seed:String
var num_enemies:int = 0

var enemy

var pseudoRandom:RandomNumberGenerator

func _ready():
	_randomiser()
	# генерация случайного количества противников
	num_enemies = randi() % MAX_ENEMIES/4
	for i in range(num_enemies):
		_enemygenerator()

func _process(delta):
	if OS.get_system_time_secs()%3==0:
		_randomiser()
		if pseudoRandom.randi()%500<10 and num_enemies<MAX_ENEMIES:
			_enemygenerator()
			num_enemies+=1

func _randomiser():
	_seed=str(OS.get_system_time_msecs())
	pseudoRandom=RandomNumberGenerator.new()
	pseudoRandom.seed=_seed.hash()

func _enemygenerator():
		# создание экземпляра сцены противника и добавление на сцену
		enemy = load(ENEMY_SCENE_PATH[pseudoRandom.randi()%2]).instance()
		enemy.position = Vector2(rand_range(0, 40*100), rand_range(0, 40*100))
		add_child(enemy)
