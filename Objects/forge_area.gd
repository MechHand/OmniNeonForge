extends Area3D

var canUse = false

@export var using = false

@onready var animation = $ForgeAnimationPlayer
@onready var animationObjs = $melters
@onready var forgeLight = $SpotLight3D

var player

func _ready():
	forgeLight.visible = false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.show_forge_icon = true
		player = body
		canUse = true
		
func _on_body_exited(body):
	if body.is_in_group("Player"):
		body.show_forge_icon = false
		player = body
		canUse = false
		
func _physics_process(delta):
	if Input.is_action_just_pressed("interact") and (using == false) and (canUse == true):
		if (player.xp == player.max_xp):
			player.upgrade()
			animation.play("forge")
	
	if using == false:
		animationObjs.visible = false
	else:
		animationObjs.visible = true
		forgeLight.visible = false

func _on_player_show_forge():
	forgeLight.visible = true
