extends Node

# Exports
@export_category("Setup")
@export var PlayerPieceScene: PackedScene

@export_category("Gameplay")
@export_range(0, 100) var screenSizeX: int = 11
@export_range(0, 100) var screenSizeY: int = 11
@export_range(0, 100) var pieceSize: int = 40

## All directions
enum directions {Left, Right, Up, Down}

## A reference to the player itself
var player = []

## Current player direction
var playerDirection: directions

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.append(PlayerPieceScene.instantiate())
	player[0].position = Vector2((screenSizeX / 2) * pieceSize, (screenSizeY / 2) * pieceSize)
	add_child(player[0])
	
	$MovementTimer.start()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	UpdatePlayerDirectionFromPlayerInput()

	if Input.is_action_just_released("TestButton"):
		doSpawn = true
	pass
	
var doSpawn: bool

func OnMovementTimerTimeout() -> void:
	if doSpawn:
		AddSnakePiece()
		doSpawn = false
		
	ShiftSnake()
	MovePlayerInCurrentDirection()
	pass
	
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
			player[0].position.y -= pieceSize
			if player[0].position.y < 0:
				player[0].position.y = screenSizeY * pieceSize
		directions.Down:
			player[0].position.y += pieceSize
			if player[0].position.y >= screenSizeY * pieceSize:
				player[0].position.y = 0
		directions.Left:
			player[0].position.x -= pieceSize
			if player[0].position.x < 0:
				player[0].position.x = screenSizeX * pieceSize
		directions.Right:
			player[0].position.x += pieceSize
			if player[0].position.x >= screenSizeX * pieceSize:
				player[0].position.x = 0
				
func AddSnakePiece():
	var newSnakeIndex = player.size()
	player.append(PlayerPieceScene.instantiate())
	player[newSnakeIndex].position = player[newSnakeIndex - 1].position
	add_child(player[newSnakeIndex])
	
func ShiftSnake():
	for i in range(len(player) - 1, -1, -1):
		if(i > 0):
			player[i].position = player[i - 1].position
