extends Control

const btnSelect = preload("res://Resources/Audio/sfx/BotaoSelecionado1.wav")
const btnClick = preload("res://Resources/Audio/sfx/ClickBotao1.wav")

@onready var menu_music = $"../../menuMusic"
@onready var game_music = $"../../gameMusic"

var isMenu = true

@onready var hud = $"../../HUD"
@onready var menuButtons = $"../Buttons"
@onready var menuElements = $"../menuElements"

signal changeCameraFocus(focus)

func _input(event):
	
	if event.is_action_pressed("pause") and not isMenu:
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state

func _ready():
	emit_signal("changeCameraFocus","menu")
	hud.visible = false
	menuButtons.visible = true
	menuElements.visible = true
	get_tree().paused = true

func _process(delta):
	pass

func _on_play_button_pressed():
	SfxManager.playSfx(btnClick, get_tree().current_scene, 0.0, 0)
	menu_music.stop()
	game_music.play(0)
	emit_signal("changeCameraFocus","RESET")
	hud.visible = true
	isMenu = false
	get_tree().paused = false
	menuButtons.visible = false
	menuElements.visible = false

func _on_play_button_mouse_entered():
	SfxManager.playSfx(btnSelect, get_tree().current_scene, 0.0, 0)

func _on_options_button_pressed():
	SfxManager.playSfx(btnClick, get_tree().current_scene, 0.0, 0)
	
func _on_options_button_mouse_entered():
	SfxManager.playSfx(btnSelect, get_tree().current_scene, 0.0, 0)

func _on_exit_button_mouse_entered():
	SfxManager.playSfx(btnSelect, get_tree().current_scene, 0.0, 0)
