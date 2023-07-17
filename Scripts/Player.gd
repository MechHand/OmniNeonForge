extends CharacterBody3D

@onready var animation = $AnimationPlayer
@onready var sprite_animation = $SpriteAnimationPlayer
@onready var attack_hitbox = $Sprite3D/AttackHitbox
@onready var item_hitbox = $ItemHitbox
@onready var damageCooldown = $damageCooldown
@onready var cameraShake = $cameraShake
@onready var upgradeAnimation = $upgradeAnimation
@onready var forgeInteractionIcon = $forgeIcon

const swordSlashSFX = preload("res://Resources/Audio/sfx/Slash.wav")
const playerHittedSFX = preload("res://Resources/Audio/sfx/PlayerHitted.wav")
const fullxpSFX = preload("res://Resources/Audio/sfx/FullXp2.wav")
const levelUpSFX = preload("res://Resources/Audio/sfx/Powerup.wav")


var moving_direction = "down"
var can_collect = false
var item_to_collect
var show_forge_icon = false

@export_category("Status")
@export var max_hp = 10
@export var max_xp = 5
@export var level = 1
@export var speed = 5.0

@export_category("Item")
@export_enum("sword", "hammer", "spear") var base_weapon: String
@export_enum("spider", "wood", "star") var fusion_element: String
@export var attack_speed = 1.0

@export_category("States")
@export var isAttacking = false

var attack_offset_amount = Vector3(0,0,0)

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var hp = 1
var xp = 0
var item_xp = 0
var damage = 1
var projectile = 0
var onDamage = false
var knockback_vector = Vector3.ZERO

signal health_changed(old_value, new_value)
signal xp_changed(old_value, new_value)
signal max_xp_changed(new_value)
signal showForge()
signal gameOver()

func _ready():
	forgeInteractionIcon.visible = false
	$upgradeSprite.visible = false
	$damageParticles.visible = false
	
	isAttacking = false
	var attack_mesh = $Sprite3D/AttackHitbox/MeshInstance3D
	attack_mesh.visible = false
	
	damage = 1 + level - 1
	xp = 0
	hp = max_hp
	emit_signal("health_changed", hp, hp)
	emit_signal("xp_changed", xp, xp)

func _physics_process(delta):
	if hp <= 0:
		emit_signal("gameOver")
		
	else:
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		#Player direction
		if Input.is_action_just_pressed("down"):
			moving_direction = "down"
		elif Input.is_action_just_pressed("up"):
			moving_direction = "up"
		elif Input.is_action_just_pressed("right"):
			moving_direction = "right"
		elif Input.is_action_just_pressed("left"):
			moving_direction = "left"
		
		#Attack input
		if Input.is_action_just_pressed("attack") and not animation.is_playing():
			SfxManager.playSfx(swordSlashSFX, get_tree().current_scene, 0.2, -2)
			sprite_animation.seek(0)
			isAttacking = true
			move_attack_hitbox(moving_direction)
			animation.play("attack")
			animation.speed_scale = attack_speed
			spawn_projectile(projectile, moving_direction)
		if isAttacking == false:
			attack_hitbox.monitorable = false
			attack_hitbox.monitoring = false
		else:
			attack_hitbox.monitorable = true
			attack_hitbox.monitoring = true
		
		var input_dir = Input.get_vector("left", "right", "up", "down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if isAttacking == true:
			var anim_pos = sprite_animation.current_animation_position
			sprite_animation.play(str("attack_",moving_direction))
			sprite_animation.speed_scale = attack_speed
			sprite_animation.seek(anim_pos)
			if direction:
				velocity.x = direction.x * speed/1.5
				velocity.z = direction.z * speed/1.5
		else:
			sprite_animation.speed_scale = 1
			if direction:
				sprite_animation.play(str("walk_",moving_direction))
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed
			else:
				sprite_animation.play(str("idle_",moving_direction))
				velocity.x = move_toward(velocity.x, 0, speed)
				velocity.z = move_toward(velocity.z, 0, speed)
		
		if knockback_vector != Vector3.ZERO:
			velocity = knockback_vector
		
		move_and_slide()
		
		if can_collect:
				if xp < max_xp:
					gainXp(item_to_collect.xp)
					item_to_collect.collected()
					item_hitbox.monitoring = false
					item_hitbox.monitoring = true
		
		if show_forge_icon and xp == max_xp:
			forgeInteractionIcon.visible = true
		else:	forgeInteractionIcon.visible = false
		
		if Input.is_action_just_pressed("testKey"):
			upgrade()
			

func take_knockback(damage_position, duration := 0.25):
	var knockback_strenght = 5
	var knockback_direction = (global_transform.origin - damage_position).normalized()
		
	if knockback_direction != Vector3.ZERO:
		knockback_vector = knockback_direction * knockback_strenght
		
		move_and_slide()

func take_damage(amount):
	SfxManager.playSfx(playerHittedSFX, get_tree().current_scene, 0.3, 0)
	emit_signal("health_changed", hp, hp - amount)
	cameraShake.play("shake")
	hp = hp - amount
	damageCooldown.start()
	
func heal_health(amount):
	emit_signal("health_changed", hp, hp + amount)
	hp = hp + amount
	
func gainXp(amount):
	emit_signal("xp_changed", xp, xp + amount)
	xp = round(xp + amount)
	print(xp, "/", max_xp)
	
	if xp == max_xp:
		emit_signal("showForge")
		SfxManager.playSfx(fullxpSFX, get_tree().current_scene, 0.3, 0)
	
func upgrade():
	emit_signal("xp_changed", 0, 0)
	xp = 0
	level += 1
	Score.gain_score(225)
	
	max_xp = round(max_xp + (max_xp / level))
	heal_health(max_hp - hp)
	emit_signal("max_xp_changed", max_xp)
	
	SfxManager.playSfx(levelUpSFX, get_tree().current_scene, 0.1, 0)
	
	if level % 3 == 0:
		speed += 0.2
		attack_speed += 0.1
		upgradeAnimation.play("speed")
	if level % 3 == 1:
		damage = 1 + level - 1
		attack_hitbox.hitbox_damage = damage
		upgradeAnimation.play("damage")
	if level % 3 == 2:
		projectile += 1
		if projectile == 1: 	upgradeAnimation.play("projectile1")
		else:	upgradeAnimation.play("projectile2")
	
func move_attack_hitbox(attack_direction):
	print(attack_direction)
	if attack_direction == "up":
		attack_hitbox.translate_object_local(Vector3(0,0,-1.2))
		attack_offset_amount = Vector3(0,0,-1.2)
	if attack_direction == "down":
		attack_hitbox.translate_object_local(Vector3(0,0,1.2))
		attack_offset_amount = Vector3(0,0,1.2)
	if attack_direction == "right":
		attack_hitbox.translate_object_local(Vector3(1.2,0,0))
		attack_offset_amount = Vector3(1.2,0,0)
	if attack_direction == "left":
		attack_hitbox.translate_object_local(Vector3(-1.2,0,0))
		attack_offset_amount = Vector3(-1.2,0,0)

func spawn_projectile(amount, direction):
	
	var projectileObj = preload("res://Objects/player_projectile_1.tscn")
	var projectileObj2 = preload("res://Objects/player_projectile_2.tscn")
	var projectileObj3 = preload("res://Objects/player_projectile_3.tscn")

	if amount != 0:
		var n = 1
		while n <= amount:
			
			if n == 1:
				var bullet = projectileObj.instantiate()
				get_parent().add_sibling(bullet)
				bullet.position = $projectileSpawn.global_position
				bullet.direction.x = $projectileSpawn.global_position.x - global_position.x
				bullet.direction.z = $projectileSpawn.global_position.z - global_position.z
			
			if n == 2:
				var bullet2 = projectileObj2.instantiate()
				get_parent().add_sibling(bullet2)
				bullet2.position = $projectileSpawn.global_position
				bullet2.direction.x = $projectileSpawn.global_position.x - global_position.x
				bullet2.direction.z = $projectileSpawn.global_position.z - global_position.z
				bullet2.speed = 16
				
			if n == 3:
				var bullet3 = projectileObj3.instantiate()
				get_parent().add_sibling(bullet3)
				bullet3.position = $projectileSpawn.global_position
				bullet3.direction.x = $projectileSpawn.global_position.x-0.5 - global_position.x
				bullet3.direction.z = $projectileSpawn.global_position.z - 0.25 - global_position.z
				
				var bullet4 = projectileObj3.instantiate()
				get_parent().add_sibling(bullet4)
				bullet4.position = $projectileSpawn.global_position
				bullet4.direction.x = $projectileSpawn.global_position.x+0.5 - global_position.x
				bullet4.direction.z = $projectileSpawn.global_position.z + 0.5 - global_position.z
			
			n += 1

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		isAttacking = false
		attack_hitbox.translate_object_local(-attack_offset_amount)

func _on_item_hitbox_area_entered(area):
	if area.is_in_group("ItemDrop"):
		can_collect = true
		item_to_collect = area
		item_xp = area.xp

func _on_item_hitbox_area_exited(area):
	if area.is_in_group("ItemDrop"):
		can_collect = false
		item_to_collect = area

func _on_damage_cooldown_timeout():
	knockback_vector = Vector3.ZERO
	onDamage = false

func _on_pause_change_camera_focus(focus):
	
	$cameraShake.play(str(focus))
	
