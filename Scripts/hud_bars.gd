extends NinePatchRect

var maximum_health = 20

func initialize(maximum_hp, maximum_xp):
	maximum_health = maximum_hp
	$HpBar.max_value = maximum_hp
	$XpBar.max_value = maximum_xp

func _on_hud_health_changed(new_value):
	$HpBar.value = new_value

func _on_hud_xp_changed(xp):
	$XpBar.value = xp

func _on_hud_max_xp_changed(max_xp):
	$XpBar.max_value = max_xp
