extends Area3D

const damageSfx1 = preload("res://Resources/Audio/sfx/InimigoMorrer.wav")
const damageSfx2 = preload("res://Resources/Audio/sfx/EnemiesHitted(UsarApenasSeNaoFicarPoluido).wav")

@export var enemy_speed = 6
@export var enemy_acel = 5

@export var enemy_health = Node3D

@onready var selfBody = $".."

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if body.onDamage == false:
			body.take_damage(selfBody.damage)
			body.take_knockback(global_transform.origin, 0.25)
			body.onDamage = true

func _on_area_entered(area):
	if area.is_in_group("Player"):
		if area.onDamage == false:
			area.take_damage(selfBody.damage)
			area.take_knockback(global_transform.origin, 0.25)
			area.onDamage = true

	if area.is_in_group("PlayerAttack"):
		if enemy_health.hp >= 1 and enemy_health.onDamage == false:
			
			randomize()
			var n = randi_range(1,2)
			if n == 1:	SfxManager.playSfx(damageSfx1, get_tree().current_scene, 0.25, -5)
			else:	SfxManager.playSfx(damageSfx2, get_tree().current_scene, 0.25, -5)
			
			enemy_health.take_damage(area.hitbox_damage)
			selfBody.take_knockback(area.get_parent().global_transform.origin, 0.25)
			monitoring = false
			monitoring = true
