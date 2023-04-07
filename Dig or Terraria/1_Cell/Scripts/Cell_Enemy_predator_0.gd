extends "res://1_Cell/Scripts/Bodyes.gd"


func _ready():
	self.hp=30
	self.max_hp=40
	set_start_bars(self.hp, self.max_hp, self.energy, self.max_energy, self.food, self.max_food)
	self.is_herbivor=false
