extends "res://1_Cell/Scripts/Bodyes.gd"

onready var imagePlayer = get_node("Cell_player_sprite")

var player_direction=Vector2()



func _ready():
	self.is_player=true
	self.hp=90
	set_start_bars(self.hp, self.max_hp, self.energy, self.max_energy, self.food, self.max_food)
	self.SPEED=200
	self.max_speed=800
	self.rotation_speed=3

func get_input():
	self.direction = 0
	self.velocity = Vector2()
	if Input.is_action_pressed("playerright"):
		self.direction += self.rotation_speed
	if Input.is_action_pressed("playerleft"):
		self.direction -= self.rotation_speed
	if Input.is_action_pressed("playerdown"):
		self.velocity = Vector2(-self.SPEED, 0).rotated(self.rotation-Pi/2)
	if Input.is_action_pressed("playerup"):
		self.velocity = Vector2(self.SPEED, 0).rotated(self.rotation-Pi/2)


func _physics_process(delta):
	get_input()

	if self.hp<=0:
		_die()
		
		
func _die():
	self.max_hp*=0.9
