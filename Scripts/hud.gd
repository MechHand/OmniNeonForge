extends Control

signal health_changed(health)
signal xp_changed(xp)
signal max_xp_changed(max_xp)
signal slow_engine()

func _ready():
	var health_player = null
	var xp_player = null
	for node in get_tree().get_nodes_in_group("Player"):
		if node.name == "Player":
			health_player = node.max_hp
			xp_player = node.max_xp
			break
	$BarNinePath.initialize(health_player, xp_player)

func _process(delta):
	pass

func _on_player_health_changed(old_value, new_value):
	emit_signal("slow_engine")
	emit_signal("health_changed", new_value)	

func _on_player_xp_changed(old_value, new_value):
	emit_signal("xp_changed", new_value)

func _on_player_max_xp_changed(new_value):
	emit_signal("max_xp_changed", new_value)

func _on_attack_hitbox_enemy_hit():
	emit_signal("slow_engine")
