extends "res://1_Cell/Scripts/Bodyes.gd"

func _ready():
	self.hp=50
	self.max_hp=70
	set_start_bars(self.hp, self.max_hp, self.energy, self.max_energy, self.food, self.max_food)
