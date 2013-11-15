Shape I, L, J, S, Z, O, T;

Grid board;
Grid preview = new Grid(300, 25, 4, 4);
Shape[] shapes;
Shape current;
Shape next;

int savedTime;
int totalTime, tempTime;
int offset_x, offset_y;
int iterations;

int level;
int score;

boolean initial;
int MIN_X, MIN_Y = 0;
int MAX_X;
int MAX_Y;

boolean paused;
boolean dead;

void setup(){
  size(425,600);
  
  board = new Grid(25, 25, 22, 10);
  preview = new Grid(300, 25, 4, 4);
  
  MAX_X = board.gColumns -1;
  MAX_Y = board.gRows - 1;
  savedTime = millis();
  totalTime = 300;
  tempTime = totalTime;
  
  iterations = 0;
  level = 1;
  
  initial = true;
  paused = false;
  dead = false;
  
  //Create shapes, add them to the array, and make new shape
  shapes = new Shape[7];
  shapes[0]  = new Shape(4, new int[] {0, 4, 8, 12}, color(255,172,64));//I
  shapes[1] = new Shape(3, new int[] {0, 3, 6, 7}, color(232, 58, 142));//L
  shapes[2] = new Shape(3, new int[] {1, 4, 6, 7}, color(77, 83, 255));//J
  shapes[3] = new Shape(3, new int[] {0, 3, 4, 7}, color(58, 232, 174));//S
  shapes[4] = new Shape(3, new int[] {1, 3, 4, 6}, color(232, 255, 77));//Z
  shapes[5] = new Shape(2, new int[] {0, 1, 2, 3}, color(0, 14, 255));//0
  shapes[6] = new Shape(3, new int[] {1, 3, 4, 7}, color(255, 147, 13));//T
  newShape();
}

void newShape(){
  //Set offset to appropriate values, positions shape
  offset_x = board.gColumns/2;
  offset_y = 0;
  
  //If initial setup, sets current and next shape to random shape from array
  if(initial){  
    current = shapes[(int)random(0, 7)];
    next = shapes[(int)random(0, 7)];
    initial = false;
  } 
  //Otherwise it sets the current to the next, and randomizes the next
  //This is the way of going to the "next" shape, and setting up
  //the next shape
  else{
    current = next;
    next = shapes[(int)random(0, 7)];
  }
}

void draw(){
  //Creates background and level information text
  fill(0);
  rect(0, 0, width, height);
  fill(255);
  textSize(14);
  text("Level: " + level, width - 75, height - 30);
  text("Score: " + score, width - 75, height - 10);
  //Displays the board grid and the preview grid  
  board.display();
  preview.display(); 
  
  if(board.isEndGame())
    dead = true;
    
  //If not paused, allow for gameplay, otherwise pause gameplay
  if(paused)
    pause();
  else if(dead)
    gameOver();
  else
    play();
}

void play(){
  //Waits for offset time for shape to move down
  if(millis() > savedTime+totalTime){
    //Pushes shape down within own matrix if possible, otherwise
    //adds 1 to the y offset, to push it down the board
    if(current.canPushDown())
      current.pushDown();
    else
      ++offset_y;
    
    savedTime = millis();
    
    //Adds one to the iterations count, for moving up in levels
    iterations++;
  } 
  
  //Level decision, goes to next level every 100 iterations*level number
  //Subtracts time between each move down the board, making shapes 
  //move more quickly. Since they move more quickly, I made the
  //number of iterations necessary to go up a level increase
  //to make each level more or less take the same amount of time
  if(iterations > 100*level && totalTime > 25){
    iterations = 0;
    totalTime -= 25;
    level++;
    score += level*200;  
  }
  
  //If the shape isn't at the bottom or hitting another shape
  if(offset_y <= MAX_Y - (current.rows -1) && board.isValidSpotBelow(-1)){
    //Whipes board and preview clean, 
    setFalse(board);
    setFalse(preview);
    //Then updates the shapes position
    mergeMatrixes(offset_x, offset_y, current, board);
    mergeMatrixes(0, 0, next, preview);
  }
  //If the shape IS at the bottom or hitting another
  else{
    //Moves the shape to the inactive array
    totalTime = tempTime;
    board.toInactive();
    //Checks 
    if(board.removeRowNum() != null){
      ArrayList<Integer> rowsToRemove = board.removeRowNum();
      
      score += rowsToRemove.size()*100;
      board.rRemove(rowsToRemove);
    }
    newShape();
  }
}

//Pause game shows PAUSED screen
void pause(){
  fill(175, 175);
  rect(0,height/2 - 50, width, 60);
  fill(0);
  textSize(24);
  text("PAUSED", width/2 - 45, height/2 - 10);
}

//Game over shows GAME OVER screen
void gameOver(){
  fill(175, 175);
  rect(0,height/2 - 50, width, 60);
  fill(0);
  textSize(24);
  text("GAME OVER! Press 'r' to restart", 60, height/2 - 10);  
}

//Sets grids active spots to false, for movement
void setFalse(Grid grid){
  for(int i = 0; i < grid.gColumns; i++)
    for(int j=0; j< grid.gRows; j++)
      grid.activeSpots[i][j] = false;  
}

void mergeMatrixes(int xOff, int yOff, Shape shape, Grid grid){
  for(int i = 0; i < shape.columns; i++)
    for(int j=0; j< shape.rows; j++){
      grid.activeSpots[i+xOff][j+yOff] = shape.sSpots[i][j];
      if(shape.sSpots[i][j] == true)
        grid.spotColor[i+xOff][j+yOff] = shape.c;
    }
}

void keyPressed(){
  if(key=='w')
    current.rot();
    
  if(key=='d' && board.isValidSpotRight())
    if(current.canPushRight())
      current.pushRight();
    else if(offset_x <= MAX_X - current.columns)
      ++offset_x;
  
  if(key=='a' && board.isValidSpotLeft())
    if(current.canPushLeft())
      current.pushLeft();
    else if(offset_x > MIN_X)
      --offset_x;
  
  if(key==' '){
    tempTime = totalTime;
    totalTime = 0;
  }
  
  if(key == ESC)
    key = 0;
  
  if(key == 0)
    if(paused)
      paused = false;
    else
      paused = true;
      
  if(key == 'r' && dead == true)
    setup();
}
