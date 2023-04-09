extends KinematicBody2D


onready var is_player : bool = false

onready var hp : int=100
export var max_hp : int=100
onready var energy : int=100
export var max_energy : int=100
onready var food : int=100
export var max_food : int=100

var hp_bar_hiding_score:int = 0
var energy_bar_hiding_score:int = 0
var food_bar_hiding_score:int = 0

onready var is_herbivor : bool = true

var gravity = 120
var SPEED : int = 100
var max_speed:int = 400
var velocity = Vector2()
var rotation_speed=1.5
var distance_to_player 
var direction=0

const FLEE_DISTANCE = 2500
const CHASE_DISTANCE = 3000
const BITE_DISTANCE = 50
var last_bite_time = 0

const Pi=3.14159265

onready var player = get_node("/root/Cell_time/Cell_player")


var specs : Array = []
var special_spec

func _ready():
	set_start_bars(hp, max_hp, energy, max_energy, food, max_food)
	self.special_spec=Specs.spec_list[randi()%Specs.specs.size()]
	self.specs.append(special_spec)
	print(self.special_spec)

func _physics_process(delta):
	update_bars()
	if !is_player:
		distance_to_player = position.distance_to(player.position)
		if distance_to_player < FLEE_DISTANCE and is_herbivor:
			flee()
		elif distance_to_player < CHASE_DISTANCE:
			chase()
			
			
		else:
			self.velocity = Vector2()
		if distance_to_player < BITE_DISTANCE and can_bite():
			bite(distance_to_player)
			
		if self.hp<=0:
			die()
			player.hp=player.max_hp
			player.energy=player.max_energy
			if self.max_hp*1.5>player.max_hp :
				player.max_hp+=self.max_hp/10
				

		self.rotation = lerp_angle(self.rotation, self.direction-Pi/2, delta * self.rotation_speed)
		self.velocity = Vector2(self.SPEED, 0).rotated(self.rotation-Pi/2)
		
	else : self.rotation += self.direction * delta
	
	self.velocity.y+=gravity*delta
	self.velocity = move_and_slide(self.velocity)

	
	if (self.velocity.x>-40 and self.velocity.x<40) and (self.velocity.y>-40 and self.velocity.y<40):
		self.energy+=2
	elif (self.velocity.x<-90 or self.velocity.x>90) or (self.velocity.y<-90 or self.velocity.y>90):
		self.energy-=self.SPEED*0.007*400/self.max_speed
	
	if self.energy<10:
		self.SPEED-=self.SPEED*0.1
	elif self.energy>80:
		self.SPEED=self.max_speed/4





func set_start_bars(hp, max_hp, energy, max_energy, food, max_food):
	$health_bar.value=hp
	$health_bar.max_value=max_hp
	$energy_bar.value=energy
	$energy_bar.max_value=max_energy
	$food_bar.value=food
	$food_bar.max_value=max_food

func update_bars():
	if $health_bar.value==hp and $health_bar.value*100/$health_bar.max_value>30 and $health_bar.visible:
		if hp_bar_hiding_score<100:
			hp_bar_hiding_score+=1
		else: $health_bar.visible=false
	elif $health_bar.value!=hp and !$health_bar.visible: 
		hp_bar_hiding_score=0
		$health_bar.visible=true
	
	if $energy_bar.value==energy and $energy_bar.visible:
		if energy_bar_hiding_score<100:
			energy_bar_hiding_score+=1
		else: $energy_bar.visible=false
	elif $energy_bar.value!=energy and !$energy_bar.visible: 
		energy_bar_hiding_score=0
		$energy_bar.visible=true
	
	if $food_bar.value==food and $food_bar.visible:
		if food_bar_hiding_score<100:
			food_bar_hiding_score+=1
		else: $food_bar.visible=false
	elif $food_bar.value!=food and !$food_bar.visible: 
		food_bar_hiding_score=0
		$food_bar.visible=true
	
	$health_bar.value=hp
	$energy_bar.value=energy
	$food_bar.value=food

func flee():
	# Убегание от игрока
	self.direction = player.position - self.position
	self.direction=atan2(self.direction.y, self.direction.x)

func chase():
	# Преследование игрока
	self.direction =  self.position - player.position
	self.direction=atan2(self.direction.y, self.direction.x)



func bite(distance_to_player):
	if distance_to_player < BITE_DISTANCE/1.2: # проверяем, достаточно ли близко враг
		self.hp -= 10
	#else: # иначе враг может укусить игрока
	player.hp -= 10
	# устанавливаем время последнего укуса на текущее время
	self.last_bite_time = OS.get_ticks_msec()

func die():
	# убрать противника с карты
	queue_free()
	# выпустить частицы или проиграть звук смерти
	# увеличить очки игрока или выпустить добычу

func can_bite():
	# проверяем прошло ли больше секунды с последнего укуса
	if OS.get_ticks_msec() - self.last_bite_time > 1000:
		return true
	else:
		return false
