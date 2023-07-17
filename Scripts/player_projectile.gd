extends RigidBody3D

signal enemy_hit
@onready var particles = $GPUParticles3D

const selfSFX = preload("res://Resources/Audio/sfx/AtaqueRanged.wav")

var behaviour = int()
var direction = Vector3()
@export var damage = 1

@export var speed = 8
@export_color_no_alpha var color = Color()

func _ready():
	SfxManager.playSfx(selfSFX, get_tree().current_scene, 0.1, -1)
	
func _process(delta):
	translate(direction.normalized() * speed * delta)

func _on_visible_on_screen_enabler_3d_screen_exited():
	queue_free()

func _on_area_3d_body_entered(body):
	if body.is_in_group("Enemies"):
		emit_signal("enemy_hit")
