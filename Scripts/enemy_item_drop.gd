extends Node3D


@export_enum("spiderEye") var item_drop: String
@export var chance = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	print("created")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func collected():
	queue_free()
