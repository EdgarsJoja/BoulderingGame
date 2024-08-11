extends Control

@onready var resume_btn: Button = $List/Resume
@onready var menu_btn: Button = $List/MainMenu

var paused: bool = false


func _ready():
	hide()
	
	resume_btn.button_up.connect(unpause)
	menu_btn.button_up.connect(main_menu)

func _process(delta):
	if Input.is_action_just_pressed("ui_menu"):
		paused = !paused
		get_tree().paused = paused
		
		if paused:
			show()
		else:
			hide()


func unpause():
	paused = false
	get_tree().paused = false
	hide()

func main_menu():
	SceneLoader.load("ui/MainMenu")
	unpause()
