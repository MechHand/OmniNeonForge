extends CharacterBody3D

@export var enemy_speed = 4
@export var enemy_acel = 5
@export var target : Node3D

var Vdir = "down"

var knockback_vector = Vector3.ZERO

var damage = 4

@onready var knockback_cooldown = $knockbackCooldown
@onready var nav : NavigationAgent3D = $NavigationAgent3D
@onready var animation = $SpriteBallAnimation

func _ready():
	EnemyCounter.enemyAmount += 1
	nav.velocity_computed.connect(Callable(_on_velocity_computed))
	
func update_target_location(target_location):
	nav.set_target_position(target_location)
	
func _physics_process(delta):

	if nav.is_navigation_finished():
		return
		
	var current_position: Vector3 = global_transform.origin
	var next_location = nav.get_next_path_position()
	var new_velocity = (next_location - current_position).normalized() * enemy_speed
	
	if nav.avoidance_enabled:
		nav.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
		
	if velocity.x >= 0:
		$Sprite3D.flip_h = false
	else:
		$Sprite3D.flip_h = true
	if velocity.z >= 0.45:
		Vdir = "down"
	elif velocity.z <= -0.45:
		Vdir = "Up"
	else:	Vdir = "side"
	
	animation.play(str("walk_", Vdir))
	
func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	
	if knockback_vector != Vector3.ZERO:
		velocity = knockback_vector
		
	move_and_slide()
	
func take_knockback(damage_position, duration := 0.25):
	knockback_cooldown.start()
	
	var knockback_strenght = 7.5
	var knockback_direction = (global_transform.origin - damage_position).normalized()
		
	if knockback_direction != Vector3.ZERO:
		
		knockback_vector = knockback_direction * knockback_strenght
		knockback_vector.y = 0
		
		move_and_slide()


func _on_knockback_cooldown_timeout():
	knockback_vector = Vector3.ZERO
