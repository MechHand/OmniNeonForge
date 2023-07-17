extends GPUParticles3D

@onready var bodyProjectile = $".."

var color = Color()

func _ready():
	color = bodyProjectile.color
	get_process_material().color = bodyProjectile.color
