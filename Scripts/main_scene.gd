extends Node3D

signal highlightForge()

var enemy = preload("res://Objects/enemy_test_2.tscn")
var enemy2 = preload("res://Objects/enemy_ball.tscn")


var menuMusic = preload("res://Resources/Audio/music/mainMenu.wav")
var gameMusic = preload("res://Resources/Audio/music/DavidKBD_-_Pink_Bloom_Pack_-_07_-_The_Hidden_One.ogg")

var freeze_time = 0.1
var freeze_slow = 0.1
var isGameover = false

@onready var gameover_timer = $gameOverTimer
@onready var menu_music = $menuMusic
@onready var game_music = $gameMusic
@onready var spawnTimer = $SpawnTimer
@onready var player = $Player
@onready var enemySpawner = $enemySpawner

var spawnerposition = [Vector3(-23,1,36), Vector3(-23, 1, 14), Vector3(-8, 1, 25), Vector3(22, 1, 29), Vector3(34, 1, 11), Vector3(31, 1, -4), Vector3(9, 1, -27), Vector3(-8, 1, -29), Vector3(-28, 1, -15)]

var spawner

func _ready():
	menu_music.play(0)
	EnemyCounter.enemyAmount = 0
	
	spawnTimer.stop()
	if spawnTimer.is_stopped():
		spawnTimer.start()

func _process(delta):
	get_tree().call_group("Enemies", "update_target_location", player.global_transform.origin)
	
	if Input.is_action_just_pressed("testKey"):
		slow_engine(1)
		spawnEnemies()

func spawnEnemies():
	randomize()
	var enemyChoosen
	
	if player.level > 4:
		enemyChoosen = randi_range(1,2)
	else: enemyChoosen = 1
	
	match enemyChoosen:
		1: spawner = enemy.instantiate()
		2: spawner = enemy2.instantiate()
	
	spawner.position = enemySpawner.global_position
	add_child(spawner)

func moveSpawner():
	randomize()
	enemySpawner.set_position(spawnerposition.pick_random())

func _on_spawn_timer_timeout():
	moveSpawner()
	randomize()
	for n in randi_range(0, 3):
		if EnemyCounter.enemyAmount < 15:
			spawnEnemies()

func slow_engine(amount):
	Engine.time_scale = freeze_slow
	await get_tree().create_timer((freeze_time * amount) * freeze_slow).timeout
	Engine.time_scale = 1
	
	if isGameover:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func _on_hud_slow_engine():
	if not isGameover:
		slow_engine(5)

func _on_attack_hitbox_enemy_hit():
	if not isGameover:
		slow_engine(4)

func _on_player_projectile_1_enemy_hit():
	if not isGameover:
		slow_engine(5)

func _on_exit_button_pressed():
	get_tree().quit()

func _on_player_game_over():
		isGameover = true
		slow_engine(10)

