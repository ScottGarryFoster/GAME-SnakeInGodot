extends Node

# Exports
@export_category("Setup")
@export var PlayerPieceScene: PackedScene

@export_category("Gameplay")
@export_range(0, 100) var screenSizeX: int = 11
@export_range(0, 100) var screenSizeY: int = 11
@export_range(0, 100) var pieceSize: int = 40
@export_range(-1280,1280) var screenOffsetX: int = 0
@export_range(-1280,1280) var screenOffsetY: int = 0

## All directions
enum directions {Left, Right, Up, Down}

## A reference to the player itself
var player = []

## Current player direction
var playerDirection: directions

## The player position in the game space not world space
var playerPositionInGameSpace: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerPositionInGameSpace = Vector2i(screenSizeX / 2, screenSizeY / 2)
	player.append(PlayerPieceScene.instantiate())
	UpdatePlayerPosition(playerPositionInGameSpace)
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

func UpdatePlayerPosition(GamespacePosition: Vector2i):
	player[0].position = Vector2(
		screenOffsetX + (GamespacePosition.x * pieceSize), 
		screenOffsetY + (GamespacePosition.y * pieceSize))

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
			playerPositionInGameSpace.y -= 1
			if playerPositionInGameSpace.y < 0:
				playerPositionInGameSpace.y = screenSizeY
		directions.Down:
			playerPositionInGameSpace.y += 1
			if playerPositionInGameSpace.y >= screenSizeY:
				playerPositionInGameSpace.y = 0
		directions.Left:
			playerPositionInGameSpace.x -= 1
			if playerPositionInGameSpace.x < 0:
				playerPositionInGameSpace.x = screenSizeX
		directions.Right:
			playerPositionInGameSpace.x += 1
			if playerPositionInGameSpace.x >= screenSizeX:
				playerPositionInGameSpace.x = 0
	
	UpdatePlayerPosition(playerPositionInGameSpace)
				
func AddSnakePiece():
	var newSnakeIndex = player.size()
	player.append(PlayerPieceScene.instantiate())
	player[newSnakeIndex].position = player[newSnakeIndex - 1].position
	add_child(player[newSnakeIndex])
	
func ShiftSnake():
	for i in range(len(player) - 1, -1, -1):
		if(i > 0):
			player[i].position = player[i - 1].position
