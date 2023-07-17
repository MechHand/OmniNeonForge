extends Area3D

@export_enum("spider") var item : String
@onready var timer = $queueFreeTimer
@onready var animation = $AnimationPlayer

var SFXplayed = false

const getxpSFX = preload("res://Resources/Audio/sfx/ColetarXpNew.wav")

var xp = 1
var direction = Vector3()
var speed = 1

func _process(delta):
	direction.y = 0
	translate(direction.normalized() * speed * delta)

func collected():
	monitorable = false
	animation.play("fade")
	animation.speed_scale = 1
	timer.start()

func _on_queue_free_timer_timeout():
	queue_free()

func _on_body_entered(body):
	var player_pos
	
	if body.is_in_group("Player"):
		if not SFXplayed:
			SfxManager.playSfx(getxpSFX, get_tree().current_scene, 0.5, -5)
			SFXplayed = true
		player_pos = body.global_position - global_position
		direction = player_pos

func _on_body_exited(body):
	var player_pos
	
	if body.is_in_group("Player"):
		player_pos = body.global_position - global_position
		direction = player_pos



