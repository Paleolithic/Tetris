class Grid {
  int x, y;
  int gRows, gColumns;
  //int row_to_remove;

  boolean[][] activeSpots;
  boolean[][] inactiveSpots;
  color[][]   spotColor;


  Grid(int x, int y, int gRows, int gColumns) {
    this.x = x;
    this.y = y;
    this.gRows = gRows;
    this.gColumns = gColumns;
    activeSpots = new boolean[gColumns][gRows];
    inactiveSpots = new boolean[gColumns][gRows];
    spotColor = new color[gColumns][gRows];
  }

  void display() {
    println(totalTime);
    createGrid();
  }

  void createGrid() {
    stroke(0);

    for (int i = 0; i < gColumns; i++) {
      for (int j = 0; j < gRows; j++) {
        if (inactiveSpots[i][j] == true || activeSpots[i][j] == true) {
          color c = spotColor[i][j];
          fill(c);
        }
        else
          fill(255);
        //Make grid 25 pixels from top, 25 from left, 25 from bottom
        rect((i*25)+x, (j*25)+y, 25, 25);
      }
    }
  }

  boolean isValidSpotBelow(int yOff) {
    for (int i = 0; i < gColumns; i++)
      for (int j = gRows-2; j >=0 ; j--)
        if (inactiveSpots[i][j-yOff] == true && activeSpots[i][j] == true)
          return false;

    return true;
  }

  boolean isValidSpotLeft() {
    for (int i = 1; i < gColumns; i++)
      for (int j = 0; j < gRows; j++) 
        if (inactiveSpots[i-1][j] == true && activeSpots[i][j] == true) 
          return false;
        
    return true;
  }

  boolean isValidSpotRight() {
    for (int i = 0; i < gColumns -1; i++)
      for (int j = 0; j < gRows; j++)
        if (inactiveSpots[i+1][j] == true && activeSpots[i][j] == true)
          return false;
    
    return true;
  }

  ArrayList<Integer> removeRowNum() {
    int numTrue = 1;
    ArrayList<Integer> rowsToRemove = new ArrayList<Integer>();

    for (int j = 0; j < gRows; j++) {
      for (int i = 0; i < gColumns; i++) {
        if (inactiveSpots[i][j] == true) {
          numTrue++;
          if (numTrue == gColumns) {
            rowsToRemove.add(j);
          }
        }
      }
      numTrue = 0;
    }
    return rowsToRemove;
  }
  
  void rRemove(ArrayList<Integer> rowsToRemove) {
    for (int j = 0; j < rowsToRemove.size(); j++)
      for (int i = 0; i < gColumns; i++)
        inactiveSpots[i][rowsToRemove.get(j)] = false;

    for (int k = 0; k < rowsToRemove.size(); k++)
      moveDown();
  }

  void moveDown() {
    for (int i = 0; i < gColumns; i++) {
      for (int j = gRows-1; j > 0; j--) {
        if (inactiveSpots[i][j] == false && inactiveSpots[i][j-1] == true) {
          inactiveSpots[i][j] = inactiveSpots[i][j-1];
          inactiveSpots[i][j-1] = false;
        }
      }
    }
  }

  void toInactive() {
    for (int i = 0; i < gColumns; i++) {
      for (int j = 0; j < gRows; j++) {
        if (inactiveSpots[i][j] == false && activeSpots[i][j] == true) {
          inactiveSpots[i][j] = activeSpots[i][j];
          activeSpots[i][j] = false;
        }
      }
    }
  }
  
  boolean isEndGame(){
    for(int i = 0; i < gColumns; i++)
      if(inactiveSpots[i][0] == true)
        return true; 
    for(int i = 0; i < gColumns; i++)
      for(int j = 0; j < gRows; j++)
        if(inactiveSpots[i][j] == true && activeSpots[i][j] == true)
          return true;
    return false;
  }
}

