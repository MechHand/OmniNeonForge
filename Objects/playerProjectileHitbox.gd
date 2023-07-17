extends Area3D

@onready var selfBody = $".."
var hitbox_damage = 1

func _ready():
	hitbox_damage = selfBody.damage

