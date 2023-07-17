extends Area3D

signal enemy_hit

@export var hitbox_damage = 1

func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		emit_signal("enemy_hit")
