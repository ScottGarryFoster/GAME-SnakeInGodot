extends Node

# Exports
@export_category("Setup")

## The Player Tile Piece to spawn
@export var PlayerPieceScene: PackedScene

## The Collectable Scene to spawn
@export var CollectableScene: PackedScene

@export_category("Gameplay")
## The Width in Tiles of the moveable screen
@export_range(0, 100) var screenSizeX: int = 11

## The height in Tiles of the moveable screen
@export_range(0, 100) var screenSizeY: int = 11

## The size of each piece, use to move the player by this amount.
@export_range(0, 100) var pieceSize: int = 40

## How much in pixels to move the playable screen (X)
@export_range(-1280,1280) var screenOffsetX: int = 0

## How much in pixels to move the playable screen (Y)
@export_range(-1280,1280) var screenOffsetY: int = 0

## All directions
enum directions {Left, Right, Up, Down}

## A reference to the player itself
var player = []

## Current player direction
var playerDirection: directions

## The player position in the game space not world space
var playerPositionInGameSpace: Vector2i

## Spawned Collectable
var currentCollectable: Area2D

## Random number generator
var random = RandomNumberGenerator.new()

## True means next movement a new snake piece will spawn
var doSpawnSnakePiece: bool

## Current score
var currentScore: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateScore(0)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	UpdatePlayerDirectionFromPlayerInput()

	pass

func StartNewGame():
	playerPositionInGameSpace = Vector2i(screenSizeX / 2, screenSizeY / 2)
	player.append(PlayerPieceScene.instantiate())
	UpdatePlayerPosition(playerPositionInGameSpace)
	add_child(player[0])
	UpdateScore(0)
	
	# Hook up the collectable
	if player[0].has_signal("area_entered"):
		player[0].connect("area_entered", Callable(self, "OnPlayerAreaEntered"))
	
	SpawnCollectable()
	$MovementTimer.start()
	
	pass

func GameOver():
	# Hook up the collectable
	if player[0].has_signal("area_entered"):
		player[0].disconnect("area_entered", Callable(self, "OnPlayerAreaEntered"))
	
	# Clear gameboard
	get_tree().call_group("LevelPieces", "queue_free")
	player.clear()
	currentCollectable = null
	
	$MovementTimer.stop()
	
	$UserInterface.AllowGameToStart()
	pass

func UpdateScore(newScore: int):
	currentScore = newScore
	$UserInterface.SetScore(currentScore)

func UpdatePlayerPosition(GamespacePosition: Vector2i):
	player[0].position = Vector2(
		screenOffsetX + (GamespacePosition.x * pieceSize), 
		screenOffsetY + (GamespacePosition.y * pieceSize))

func OnMovementTimerTimeout() -> void:
	if doSpawnSnakePiece:
		AddSnakePiece()
		doSpawnSnakePiece = false
		
	ShiftSnake()
	MovePlayerInCurrentDirection()
	pass
	
func UpdatePlayerDirectionFromPlayerInput():
	if Input.is_action_pressed("MoveUp"):
		if playerDirection != directions.Down:
			playerDirection = directions.Up;
	if Input.is_action_pressed("MoveLeft"):
		if playerDirection != directions.Right:
			playerDirection = directions.Left;
	if Input.is_action_pressed("MoveDown"):
		if playerDirection != directions.Up:
			playerDirection = directions.Down;
	if Input.is_action_pressed("MoveRight"):
		if playerDirection != directions.Left:
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
	pass
			
func AddSnakePiece():
	var newSnakeIndex = player.size()
	player.append(PlayerPieceScene.instantiate())
	player[newSnakeIndex].position = player[newSnakeIndex - 1].position
	add_child(player[newSnakeIndex])
	pass
	
func ShiftSnake():
	for i in range(len(player) - 1, -1, -1):
		if(i > 0):
			player[i].position = player[i - 1].position
	pass
	
func OnPlayerAreaEntered(body: Node2D) -> void:
	for group in body.get_groups():
		if(group == "Collectable"):
			doSpawnSnakePiece = true
			UpdateScore(currentScore + 1)
			SpawnCollectable()
		elif(group == "Player"):
			GameOver()
	pass # Replace with function body.
	
func SpawnCollectable():
	if(currentCollectable == null):
		currentCollectable = CollectableScene.instantiate()
		add_child(currentCollectable)
	
	var randomX: int = 0
	var randomY: int = 0
	while(true):
		randomX = random.randi_range(0, screenSizeX - 1)
		randomY = random.randi_range(0, screenSizeY - 1)
		
		var foundConflict: bool = false
		for i in range(len(player)):
			if(player[i].position.x == screenOffsetX + (randomX * pieceSize) && 
				player[i].position.y == screenOffsetY + (randomY * pieceSize)):
					foundConflict = true
					# Slight optimisation to not keep looking
					continue
		
		if(!foundConflict):
			# Did not find a player piece in random position
			break
	
	currentCollectable.position = Vector2(
		screenOffsetX + (randomX * pieceSize),
		 screenOffsetY + (randomY * pieceSize))
	pass


func OnGameStartFromUserInterface() -> void:
	StartNewGame()
	pass # Replace with function body.
