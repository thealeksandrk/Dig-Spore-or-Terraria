extends KinematicBody2D

var speed : int = 2000
var jumpforce : int = 550
var gravity = 600

var vel = Vector2()

onready var imagePlayer = get_node("Hero")

func _physics_process(delta):
	vel.x=0

	if Input.is_action_pressed("playerleft"):
		vel.x-=speed
	elif Input.is_action_pressed("playerright"):
		vel.x+=speed
		
	vel.y+=gravity*delta
		
	if Input.is_action_pressed("playerjump") and is_on_floor():
		vel.y-=jumpforce
		
	vel = move_and_slide(vel,Vector2.UP)
	
	if vel.x<0:
		imagePlayer.flip_h=true
	elif vel.x>0:
		imagePlayer.flip_h=false
		
	#position.x=clamp(position.x, 0, 10000)
	#position.y=clamp(position.y, 0, 1000)

func destroy_block():
	# определяем координаты блока, находящегося перед игроком
	var block_pos = get_parent().get_node("/root/Mainscene/World/ground").world_to_map(get_global_mouse_position())*32

	# проверяем, что блок действительно находится рядом с игроком
	var player_pos = get_global_position()

	if abs(player_pos.x - block_pos.x) > 5*32 or abs(player_pos.y - block_pos.y) > 5*32:
		return

	# получаем тип блока
	var block_type = get_parent().get_node("/root/Mainscene/World/ground").get_cell(block_pos.x/32, block_pos.y/32)
	# если блок пустой, то ничего не делаем
	if block_type == -1:
		return

	# уничтожаем блок и добавляем его в инвентарь
	get_parent().get_node("/root/Mainscene/World/ground").set_cell(block_pos.x/32, block_pos.y/32, -1)

	#get_parent().get_node("Inventory").add_item(block_type, 1)
	print("done")


func _process(delta):
	if Input.is_mouse_button_pressed(1):
		destroy_block()
