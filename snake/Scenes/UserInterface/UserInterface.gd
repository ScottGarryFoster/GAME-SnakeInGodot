extends CanvasLayer

signal StartGame

var allowGameToStart: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ShowIntroduction()
	allowGameToStart = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Action")):
		$MessageTimer.start()
	pass

func SetScore(newValue: int):
	$Score.text = str(newValue)
	pass
	
func HideIntroduction():
	$"Introduction/Tutorial Label".hide()
	$Introduction/Title.hide()
	pass
	
func ShowIntroduction():
	$"Introduction/Tutorial Label".show()
	$Introduction/Title.show()
	pass

func AllowGameToStart():
	ShowIntroduction()
	allowGameToStart = true
	pass

func OnMessageTimerTimeout() -> void:
	if(allowGameToStart):
		StartGame.emit()
		HideIntroduction()
		allowGameToStart = false
	
	pass # Replace with function body.
