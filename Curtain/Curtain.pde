/*
  Curtain
  by Kara Ngamsopee
  
    Will change the background to blue when the button is pressed
    Will lower curtain based on the potentiometer
    
 */
 

// Importing the serial library to communicate with the Arduino 
import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;      

// Data coming in from the data fields
// data[0] = "1" or "0"                  -- BUTTON
// data[1] = 0-4095, e.g "2049"          -- POT VALUE
// data[2] = 0-4095, e.g. "1023"        -- LDR value
String [] data;

int switchValue = 0;
int potValue = 0;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 2;

// animated ball
int minPotValue = 0;
int maxPotValue = 4095;    // will be 1023 on other systems
int minSize = 0;
int maxSize = 700;
int ballDiameter = 20;
int hBallMargin = 40;    // margin for edge of screen
int xBallMin;        // calculate on startup
int xBallMax;        // calc on startup
float xBallPos;        // calc on startup, use float b/c speed is float
int yBallPos;        // calc on startup
int direction = -1;    // 1 or -1

//-- image paramers
PImage cloud;
float xImagePos = 0;
float yImagePos = 0;

int minLDRValue = 400;
int maxLDRValue = 1700;
int minAlphaValue = 0;
int maxAlphaValue = 255;

void setup ( ) {
  size (550,  700);    
  
  // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  //-- use your port name
  myPort  =  new Serial (this, "/dev/cu.SLAB_USBtoUART",  115200); 
  

  // load our image, use your own!
  cloud = loadImage("cloud.jpg");
  imageMode(CORNER);
  xImagePos = 20;
  yImagePos = 20;
} 


// We call this to get the data 
void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();  
    print(inBuffer);
    
    // This removes the end-of-line from the string 
    inBuffer = (trim(inBuffer));
    
    // This function will make an array of TWO items, 1st item = switch value, 2nd item = potValue
    data = split(inBuffer, ',');
   
   // we have THREE items — ERROR-CHECK HERE
   if( data.length >= 3 ) {
      switchValue = int(data[0]);           // first index = switch value 
      potValue = int(data[1]);               // second index = pot value
   }
  }
} 

//-- change background to red if we have a button
void draw ( ) {  
  // every loop, look for serial information
  checkSerial();
  drawBackground();
  drawCurtain();
} 

// if input value is 1 (from ESP32, indicating a button has been pressed), change the background
void drawBackground() {
   if( switchValue == 1 )
    background( 207, 231, 255 );
  else
    background(0); 
}

//-- animate ball left to right, use potValue to change speed
void drawCurtain() {
    fill(255,255,255);
    float sizeChange = map(potValue, minPotValue, maxPotValue, minSize, maxSize);
    rect(0,0,600,sizeChange);
    
    if(sizeChange < 20) {
    textSize(32);
    fill(255);
    image(cloud,0,0);
    text("good morning :)", 200, 350);
    }
    
    if(sizeChange > 680) {
    textSize(32);
    fill(0);
    text("good night ZzZz", 200, 350);
    } 
    
}

void drawSky() {

  image(cloud, xImagePos, yImagePos);
}
