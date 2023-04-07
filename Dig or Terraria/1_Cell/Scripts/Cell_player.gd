extends "res://1_Cell/Scripts/Bodyes.gd"

onready var imagePlayer = get_node("Cell_player_sprite")


func _ready():
	self.is_player=true
	self.hp=90
	set_start_bars(self.hp, self.max_hp, self.energy, self.max_energy, self.food, self.max_food)
	self.SPEED=200
	self.max_speed=800

func _physics_process(delta):
	self.velocity.x=0
	self.velocity.y=0
	
	if Input.is_action_pressed("playerleft"):
		self.velocity.x-=self.SPEED
	elif Input.is_action_pressed("playerright"):
		self.velocity.x+=self.SPEED
	if Input.is_action_pressed("playerup"):
		self.velocity.y-=self.SPEED
	elif Input.is_action_pressed("playerdown"):
		self.velocity.y+=self.SPEED

	if Input.is_action_pressed("playerjump") and is_on_floor():
		pass
		
	
	if self.velocity.x<0 and self.velocity.y==0:
		imagePlayer.rotation_degrees=270
	elif self.velocity.x<0 and self.velocity.y<0:
		imagePlayer.rotation_degrees=315
	elif self.velocity.x==0 and self.velocity.y<0:
		imagePlayer.rotation_degrees=0
	elif self.velocity.x<0 and self.velocity.y>gravity:
		imagePlayer.rotation_degrees=225
	elif self.velocity.x>0 and self.velocity.y<0:
		imagePlayer.rotation_degrees=45
	elif self.velocity.x>0 and self.velocity.y==0:
		imagePlayer.rotation_degrees=90
	elif self.velocity.x>0 and self.velocity.y>gravity:
		imagePlayer.rotation_degrees=135
	elif self.velocity.x==0 and 0<self.velocity.y and self.velocity.y<=gravity:
		imagePlayer.rotation_degrees=180

	if self.hp<=0:
		_die()
		
		
func _die():
	self.max_hp*=0.9
