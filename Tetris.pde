Shape I, L, J, S, Z, O, T;

Grid board = new Grid(25, 25, 22, 10);
Grid preview = new Grid(300, 25, 4, 4);
Shape[] shapes;
Shape current;
Shape next;

int savedTime;
int totalTime = 250;
int offset_x;
int offset_y;

boolean initial;
final int MIN_X = 0;
final int MIN_Y = 0;
final int MAX_X = board.gColumns -1;
final int MAX_Y = board.gRows - 1;

void setup(){
  size(425,600);
  savedTime = millis();
  
  initial = true;
  
  shapes = new Shape[7];
  shapes[0]  = new Shape(4, new int[] {0, 4, 8, 12}, color(0, 0, 175));//I
  shapes[1] = new Shape(3, new int[] {0, 3, 6, 7}, color(0, 175, 175));//L
  shapes[2] = new Shape(3, new int[] {1, 4, 6, 7}, color(175, 175, 0));//J
  shapes[3] = new Shape(3, new int[] {0, 3, 4, 7}, color(175, 0, 0));//S
  shapes[4] = new Shape(3, new int[] {1, 3, 4, 6}, color(255, 0, 0));//Z
  shapes[5] = new Shape(2, new int[] {0, 1, 2, 3}, color(255, 0, 255));//0
  shapes[6] = new Shape(3, new int[] {1, 3, 4, 7}, color(255, 255, 0));//T
  newShape();
}

void newShape(){
  offset_x = board.gColumns/2;
  offset_y = 0;
  
  if(initial){  
    current = shapes[(int)random(0, 6)];
    next = shapes[(int)random(0, 6)];
    initial = false;
  } else{
    current = next;
    next = shapes[(int)random(0, 6)];
  }
  //current = shapes[0];
}

void draw(){
  if(millis() > savedTime+totalTime){
    if(current.canPushDown())
      current.pushDown();
    else
      ++offset_y;
    savedTime = millis();
  } 
  
  if(offset_y <= MAX_Y - (current.rows -1) && board.isValidSpotBelow()){
    setFalse(board);
    setFalse(preview);
    mergeMatrixes(offset_x, offset_y, current, board);
    mergeMatrixes(0, 0, next, preview);
  }
  else{
    board.toInactive();
    board.rRemove(board.removeRowNum());
    newShape();
  }
  
  board.display(current.c);
  preview.display(current.c); 
}

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
}
