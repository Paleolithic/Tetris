class Shape {

  int rows;
  int columns;
  int[] nums;
  boolean[][] sSpots;

  color c;

  Shape(int amt, int[] nums, color c) {
    this.columns = amt;
    this.rows = amt;
    this.c = c;
    //this.nums = nums;
    sSpots = new boolean[columns][rows];

    for (int i=0; i<nums.length;++i)
      sSpots[nums[i]%columns][nums[i]/rows] = true;

  }
  
  boolean canPushDown(){
    for (int x=0;x<sSpots.length;++x)
      if (sSpots[x][sSpots.length-1]==true)
        return false;
    return true;  
  }
  
  boolean canPushRight(){
    for (int y=0;y<sSpots.length;++y)
      if (sSpots[sSpots.length-1][y]==true)
        return false;
    return true;  
  }
  
  boolean canPushLeft(){
    for (int y=0;y<sSpots.length;++y)
      if (sSpots[0][y]==true)
        return false;
    return true;  
  }
  
  void pushDown(){
    println("Move to right");
    //boolean[][] ret = ret_; 
    boolean[][] ret = sSpots;
    for (int x=0;x<ret.length;++x) {
      for (int y=ret.length-1;y>=0;--y) {
        if (ret[x][y] == true){
          ret[x][y+1] = ret[x][y];
          ret[x][y]=false;
        }
      }
    }
  }
  
  void pushLeft(){
    println("Move to left");
    //boolean[][] ret = ret_; 
    boolean[][] ret = sSpots;
    for (int x=0;x<ret.length;++x) {
      for (int y=0;y<ret.length;++y) {
        if (ret[x][y] == true){
          ret[x-1][y] = ret[x][y];
          ret[x][y]=false;
        }
      }
    }
  }
  
  void pushRight(){
    println("Move to right");
    //boolean[][] ret = ret_; 
    boolean[][] ret = sSpots;
    for (int x=ret.length-1;x>=0;--x) {
      for (int y=0;y<ret.length;++y) {
        if (ret[x][y] == true){
          ret[x+1][y] = ret[x][y];
          ret[x][y]=false;
        }
      }
    }
  }
  
  void rot() {
    boolean[][] ret = new boolean[sSpots.length][sSpots.length]; 
    for (int x=0; x<ret.length; ++x)
      for (int y=0; y<ret.length;++y)
        ret[x][y] = sSpots[y][ret.length-1-x];

    sSpots = ret;  
  }
    
  void display(){
    
  }

}

