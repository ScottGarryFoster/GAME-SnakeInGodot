# Snake in Godot
My goal was to learn Godot and snake is my goto early project in a new engine or language. In this project I used GDScript and the basic features of the engine.

# Methods
Below explains the basic setup for this project, this is not complex and is largely an expansion of the tutorial project:
1. Player Piece are a Scene object
2. Collectables are a Scene Object
3. The Main Scene controls spawning the Player and Collectables
4. Player Pieces are stored in an array with the first item in the array as the head, shifting as it moves
5. Every new piece the last player piece is the position for the new piece on the end of the array
6. Moving around the world occurs with game cords (set with a variable) then translated to the viewport (so you can setup an offset easily)
7. User Interface is basically the same as the tutorial, message that disappears when you start and score that updates
8. Snake speeds up to a max speed of 0.15 seconds per movement (at around 35 score)
9. Colours were changed to Gameboy Palette: https://www.color-hex.com/color-palette/45299

# Gameplay
![Snake Game Gameplay](https://github.com/ScottGarryFoster/GAME-SnakeInGodot/blob/main/Development/001-Gameplay.gif?raw=true)