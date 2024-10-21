int cellSize = 10;
int cols, rows;
boolean[][] grid;
boolean[][] nextGrid;
int generation = 0;
int generationProgressionSpeed = 10; // increase this to make the gens progress slower

void setup() {
  size(600, 600);
  cols = width / cellSize;
  rows = height / cellSize;
  grid = new boolean[cols][rows];
  nextGrid = new boolean[cols][rows];
}

void draw() {
  background(0);
  drawGrid();
  
  // display generation count
  fill(255);
  textSize(16);
  text("Generation: " + generation, 10, 20);
  
  // progress generations when space is held
  if (keyPressed && key == ' ') {
    if (frameCount % generationProgressionSpeed == 0) { // controls the speed of generations passing
      nextGeneration();
    }
  }
}

void drawGrid() {
  stroke(128); // grid line color
  for (int i = 0; i <= cols; i++) {
    line(i * cellSize, 0, i * cellSize, height);
  }
  for (int j = 0; j <= rows; j++) {
    line(0, j * cellSize, width, j * cellSize);
  }
  
  
  // ----------- DRAW ALIVE CELLS ------------------
  stroke(150); // square outline color
  //noStroke();
  fill(255); // white cells
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (grid[i][j]) {
        rect(i * cellSize, j * cellSize, cellSize, cellSize);
      }
    }
  }
}

void nextGeneration() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int neighbors = countNeighbors(i, j);
      if (grid[i][j]) {
        // any live cell with two or three neighbors survives
        nextGrid[i][j] = (neighbors == 2 || neighbors == 3);
      } else {
        // any dead cell with three live neighbors becomes a live cell
        nextGrid[i][j] = (neighbors == 3);
      }
    }
  }
  // swap grids
  boolean[][] temp = grid;
  grid = nextGrid;
  nextGrid = temp;
  
  generation++;
}

int countNeighbors(int x, int y) {
  int sum = 0;
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      int col = (x + i + cols) % cols;
      int row = (y + j + rows) % rows;
      if (grid[col][row]) {
        sum++;
      }
    }
  }
  if (grid[x][y]) {
    sum--; // subtract the cell itself
  }
  return sum;
}

void mousePressed() {
  int x = mouseX / cellSize;
  int y = mouseY / cellSize;
  if (x >= 0 && x < cols && y >= 0 && y < rows) {
    if (mouseButton == LEFT) {
      grid[x][y] = true; // make cell alive on left-click
    }
  }
}

void mouseDragged() {
  int x = mouseX / cellSize;
  int y = mouseY / cellSize;

  int prevX = pmouseX / cellSize;
  int prevY = pmouseY / cellSize;

  // this makes ALL cells that have been dragged over activated
  // doesn't miss any, even at high speed
  for (int i = min(x, prevX); i <= max(x, prevX); i++) {
    for (int j = min(y, prevY); j <= max(y, prevY); j++) {
      if (i >= 0 && i < cols && j >= 0 && j < rows) {
        if (mouseButton == LEFT) {
          grid[i][j] = true;  // alive with left-click
        } else if (mouseButton == RIGHT) {
          grid[i][j] = false; // dead with right-click
        }
      }
    }
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    // reset all cells
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j] = false;
      }
    }
    generation = 0;
  }
}
