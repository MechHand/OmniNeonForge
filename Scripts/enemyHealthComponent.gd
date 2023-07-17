extends Node3D

var item_drop = preload("res://Objects/components/enemy_item_drop.tscn")
var new_item

@onready var timer = $Cooldown

@export var max_hp = 10

var hp = 1
var onDamage = false

func _ready():
	hp = max_hp

func _process(delta):
	pass

func take_damage(amount):
	if onDamage == false:
		onDamage = true
		change_hp(amount)
		timer.start()

func change_hp(amount):
	hp = hp - amount
	
func _on_cooldown_timeout():
	onDamage = false
	if hp < 1:
		EnemyCounter.enemyAmount -= 1
		new_item = item_drop.instantiate()
		new_item.position = global_position
		Score.gain_score(100)
		get_parent().add_sibling(new_item)
		get_parent().queue_free()
