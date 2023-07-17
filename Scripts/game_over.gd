extends CanvasLayer

const gameoverSFX = preload("res://Resources/Audio/sfx/GameOver.wav")

@onready var scoreElement = $scoreElement
# Called when the node enters the scene tree for the first time.
func _ready():
	SfxManager.playSfx(gameoverSFX, get_tree().current_scene, 0.0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scoreElement.text = str("Score: ",Score.score, " | Highscore: ", Score.highscore)

func _on_retry_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")
