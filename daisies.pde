// Daisies, a clone of Theo Watson's daisies: https://vimeo.com/3870152
// https://github.com/eedala/daisies
// License: GPL3, all credits go to Theo.

//------------------------------------------------------------------------
// List of images, first index is the size of the flower, and then
// a list of that flower in different sizes.
PImage[][] img = new PImage[9][5];

// Raster/grid to place the flowers on, to avoid too much clustering:
int raster = 4;

// Screen resolution, smaller is faster:
//int screenW = 640;
//int screenH = 360;
int screenW = 1920;
int screenH = 1080;
//int screenW = 2560;
//int screenH = 1440;

// Maximum distance between mouse coordinates that is still considered
// to be a jumpy mouse.  Then the mouse movement is interpolated
// between the previous and current mouse position.  Above that
// distance, the mouse is considered to have moved out of the window
// and back again at a different place.  Interpolating in this case
// would plow a straight line through the flowers.
int maxDist = screenH * screenH / 4;

// Previous mouse position (last round through draw()):
int previousMouseX = 0;
int previousMouseY = 0;

// Maximum number of flowers to show:
int maxDaisies = 500 * screenW / 640 * screenH  / 360;

// Data per daisy:
int[] daisyX    = new int[maxDaisies];
int[] daisyY    = new int[maxDaisies];
int[] daisyNo   = new int[maxDaisies];
int[] daisyWait = new int[maxDaisies];

// Translate x/y coordinate to a list of daisies that are affected
// when clicked at this x/y coordinate:
IntList[][] daisyRadius = new IntList[screenW][screenH];

// Diameter of the eraser around the mouse:
int eraseDia = 50;
int eraseDiaSq = eraseDia * eraseDia;

//------------------------------------------------------------------------
// Fill the lookup-table daisyRadius[][]  for the daisy #d.
// All coordinates in a square of eraseDia^2 pixels (with the
// daisy in the middle) will hit the daisy:
void createRadiusList(int d)
{
  for (int x = daisyX[d] - eraseDia;  x < daisyX[d] + eraseDia;  x++)
  {
    for (int y = daisyY[d] - eraseDia;  y < daisyY[d] + eraseDia;  y++)
    {
      if ((x > 0) && (x < screenW) && (y > 0) && (y < screenH))
      {
        daisyRadius[x][y].append(d);
      }
    }
  }
}


//------------------------------------------------------------------------
// Create all daisies at random coordinates on the given grid:
// Each daisy has a random image and a random time until it appears:
void createDaisies()
{
  for(int d = 0;  d < maxDaisies;  d++)
  {
    // Displays the image at its actual size at point (0,0)
    daisyX[d]  = raster * int(random(width/raster));
    daisyY[d]  = raster * int(random(height/raster));
    daisyNo[d] = int(random(img.length));
    daisyWait[d] = int(random(60));
    createRadiusList(d);
  }
}


//------------------------------------------------------------------------
// Draw all daisies over a background.  Depending on the wait time,
//  a daisy is not shown at all, or small, bigger, and final size:
void drawDaisies()
{
  background(20,90,30);
  
  for(int d = 0;  d < maxDaisies;  d++)
  {
    if (daisyWait[d] == 0)
    {
      image(img[daisyNo[d]][0], daisyX[d], daisyY[d]);
    }
    else if (daisyWait[d] < 5)
    {
      image(img[daisyNo[d]][1], daisyX[d], daisyY[d]);
    }
    else if (daisyWait[d] < 10)
    {
      image(img[daisyNo[d]][2], daisyX[d], daisyY[d]);
    }
    else if (daisyWait[d] < 15)
    {
      image(img[daisyNo[d]][3], daisyX[d], daisyY[d]);
    }
    else if (daisyWait[d] < 20)
    {
      image(img[daisyNo[d]][4], daisyX[d], daisyY[d]);
    }
  }
}


//------------------------------------------------------------------------
// Given an x/y coordinate, erase all flowers that are affected:
// Erasing is more like picking the flower and pulling it out
// with the roots.  That means the flower will grow again at the
// same place.  The user does not notice.
void eraseNear(int x, int y)
{
  for(int index = 0;  index < daisyRadius[x][y].size();  index++)
  {
    daisyWait[daisyRadius[x][y].get(index)] = 30 + int(random(25));
  }
}


//------------------------------------------------------------------------
// Decrease the waiting time for each daisy:
void countdownWait()
{
  for(int d = 0;  d < maxDaisies;  d++)
  {
    if (daisyWait[d] > 0)
    {
      daisyWait[d]--;
    }
  }
}


//------------------------------------------------------------------------
// Initially (before setup()), set the size of the window:
void settings()
{
    size(screenW, screenH);
}


//------------------------------------------------------------------------
// Setup: Load all images from disk, create all data, and prepare
// for the main loop.
void setup() {
  // The image file must be in the data folder of the current sketch 
  // to load successfully
  img[0][0] = loadImage("blume-4.png");  // Load the image into the program
  img[0][1] = loadImage("blume-5.png");  // Load the image into the program
  img[0][2] = loadImage("blume-6.png");  // Load the image into the program
  img[0][3] = loadImage("blume-7.png");  // Load the image into the program
  img[0][4] = loadImage("blume-8.png");  // Load the image into the program

  img[1][0] = loadImage("blume-5.png");  // Load the image into the program
  img[1][1] = loadImage("blume-6.png");  // Load the image into the program
  img[1][2] = loadImage("blume-7.png");  // Load the image into the program
  img[1][3] = loadImage("blume-8.png");  // Load the image into the program
  img[1][4] = loadImage("blume-9.png");  // Load the image into the program
  
  img[2][0] = loadImage("blume-5.png");  // Load the image into the program
  img[2][1] = loadImage("blume-6.png");  // Load the image into the program
  img[2][2] = loadImage("blume-7.png");  // Load the image into the program
  img[2][3] = loadImage("blume-8.png");  // Load the image into the program
  img[2][4] = loadImage("blume-9.png");  // Load the image into the program
  
  img[3][0] = loadImage("blume-6.png");  // Load the image into the program
  img[3][1] = loadImage("blume-7.png");  // Load the image into the program
  img[3][2] = loadImage("blume-8.png");  // Load the image into the program
  img[3][3] = loadImage("blume-9.png");  // Load the image into the program
  img[3][4] = loadImage("blume-10.png");  // Load the image into the program
  
  img[4][0] = loadImage("blume-6.png");  // Load the image into the program
  img[4][1] = loadImage("blume-7.png");  // Load the image into the program
  img[4][2] = loadImage("blume-8.png");  // Load the image into the program
  img[4][3] = loadImage("blume-9.png");  // Load the image into the program
  img[4][4] = loadImage("blume-10.png");  // Load the image into the program
  
  img[5][0] = loadImage("blume-6.png");  // Load the image into the program
  img[5][1] = loadImage("blume-7.png");  // Load the image into the program
  img[5][2] = loadImage("blume-8.png");  // Load the image into the program
  img[5][3] = loadImage("blume-9.png");  // Load the image into the program
  img[5][4] = loadImage("blume-10.png");  // Load the image into the program
  
  img[6][0] = loadImage("blume-7.png");  // Load the image into the program
  img[6][1] = loadImage("blume-8.png");  // Load the image into the program
  img[6][2] = loadImage("blume-9.png");  // Load the image into the program
  img[6][3] = loadImage("blume-10.png");  // Load the image into the program
  img[6][4] = loadImage("blume-11.png");  // Load the image into the program

  img[7][0] = loadImage("blume-7.png");  // Load the image into the program
  img[7][1] = loadImage("blume-8.png");  // Load the image into the program
  img[7][2] = loadImage("blume-9.png");  // Load the image into the program
  img[7][3] = loadImage("blume-10.png");  // Load the image into the program
  img[7][4] = loadImage("blume-11.png");  // Load the image into the program
  
  img[8][0] = loadImage("blume-8.png");  // Load the image into the program
  img[8][1] = loadImage("blume-9.png");  // Load the image into the program
  img[8][2] = loadImage("blume-10.png");  // Load the image into the program
  img[8][3] = loadImage("blume-11.png");  // Load the image into the program
  img[8][4] = loadImage("blume-12.png");  // Load the image into the program
  
  frameRate(20);
  
  // Create an empty list at each position of the lookup-table
  // so that we can add daisies later.
  for (int x = 0;  x < screenW;  x++)
  {
    for (int y = 0;  y < screenH;  y++)
    {
      daisyRadius[x][y] = new IntList();
    }
  }

  createDaisies();
  imageMode(CENTER);
  drawDaisies();
}


//------------------------------------------------------------------------
// Main loop.
void draw() {
  drawDaisies();

  countdownWait();
  
  // Detect large mouse movements and interpolate to compensate
  // on slow computers.  Otherwise the flowers would be erased
  // only every now and then when you move the mouse too quickly:
  int dX = mouseX - previousMouseX;
  int dY = mouseY - previousMouseY;
  int distSq = dX * dX + dY *dY;
  if ((distSq > eraseDiaSq) && (distSq < maxDist))
  {
    int steps = int(sqrt(distSq) / float(eraseDia));
    int stepX = dX / steps;
    int stepY = dY / steps;
    // Only do (steps - 1) iterations because eraseNear() is called
    // also after this if-statement:
    for (int i = 1;  i < steps;  i++)
    {
      eraseNear(previousMouseX + stepX, previousMouseY + stepY);
      previousMouseX += stepX;
      previousMouseY += stepY;
    }
  }
  
  // Erase flowers around the mouse:
  eraseNear(mouseX, mouseY);

  // Remember the position of the mouse for next round:
  previousMouseX = mouseX;
  previousMouseY = mouseY;
}