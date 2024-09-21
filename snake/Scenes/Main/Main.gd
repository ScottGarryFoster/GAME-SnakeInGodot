extends Node

# Exports
@export_category("Setup")
@export var PlayerPieceScene: PackedScene

@export_category("Gameplay")
@export_range(0, 100) var screenSizeX: int = 11
@export_range(0, 100) var screenSizeY: int = 11
@export_range(0, 100) var pieceSize: int = 40

# Internals
var playerPosition: Vector2i
var player
enum directions {Left, Right, Up, Down}
var playerDirection: directions

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerPosition = Vector2((screenSizeX / 2) * pieceSize, (screenSizeY / 2) * pieceSize)
	
	player = PlayerPieceScene.instantiate()
	player.position = playerPosition
	add_child(player)
	
	$MovementTimer.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	UpdatePlayerDirectionFromPlayerInput()
	pass

func OnMovementTimerTimeout() -> void:
	MovePlayerInCurrentDirection()
	pass # Replace with function body.
	
func UpdatePlayerDirectionFromPlayerInput():
	if Input.is_action_pressed("MoveUp"):
		playerDirection = directions.Up;
	if Input.is_action_pressed("MoveLeft"):
		playerDirection = directions.Left;
	if Input.is_action_pressed("MoveDown"):
		playerDirection = directions.Down;
	if Input.is_action_pressed("MoveRight"):
		playerDirection = directions.Right;
	pass

func MovePlayerInCurrentDirection():
	match playerDirection:
		directions.Up:
			playerPosition.y -= pieceSize
			if playerPosition.y < 0:
				playerPosition.y = screenSizeY * pieceSize
		directions.Down:
			playerPosition.y += pieceSize
			if playerPosition.y >= screenSizeY * pieceSize:
				playerPosition.y = 0
		directions.Left:
			playerPosition.x -= pieceSize
			if playerPosition.x < 0:
				playerPosition.x = screenSizeX * pieceSize
		directions.Right:
			playerPosition.x += pieceSize
			if playerPosition.x >= screenSizeX * pieceSize:
				playerPosition.x = 0
		
	player.position = playerPosition
