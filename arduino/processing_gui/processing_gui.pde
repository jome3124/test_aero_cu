import controlP5.*;
import processing.serial.*;

Serial port;

ControlP5 cp5;
PFont font;

float xPos = 0;
float yPos = 0;
int ctr = 0;
boolean preLaunch = false;
boolean launch = false;
Button preLaunchButton, launchButton;
PrintWriter output;
int numByte = 0;
int force;
int pressure = 250;

void setup() { //same as arduino program

  size(800, 400); //window size (width, height)
  
  printArray(Serial.list());  //prints all available serial ports
  
  port = new Serial(this, "COM3", 9600); // have connected arduino to COMX
  
  output = createWriter("testing.txt");
  
  //add some buttons
  cp5 = new ControlP5(this);
  font = createFont("calibri light", 20); //custom fonts for buttons and title
  
  preLaunchButton = cp5.addButton("Pre_Launch_Ready")  // "red" is the name of button
  .setPosition(100, 50) // x and y coordinates of the upper left corner of the button
  .setSize(200, 80)     // (width, height)
  .setFont(font)
  .setColorBackground(color(0, 0, 0))
  ;
  
  launchButton = cp5.addButton("Launch_Rocket")  // "red" is the name of button
  .setPosition(500, 50) // x and y coordinates of the upper left corner of the button
  .setSize(200, 80)     // (width, height)
  .setFont(font)
  .setColorBackground(color(0, 0, 0))
  ;
  
  cp5.addButton("reset")  // "red" is the name of button
  .setPosition(350, 50) // x and y coordinates of the upper left corner of the button
  .setSize(100, 80)     // (width, height)
  .setFont(font)
  ;
  
  cp5.addButton("Initialize") //initialize the data coming in
  .setPosition(10, 20)
  .setSize(100, 20)
  ;
}

//Lets add some functions to our buttons
//so when you press any button, it sends the correct value over serial

void Pre_Launch_Ready() {
  port.write('r');
  preLaunchButton.setColorBackground(color(255, 0, 0));
  preLaunch = true;
}

void Launch_Rocket() {
  port.write('b');
  launchButton.setColorBackground(color(255, 0, 0));
  launch = true;
}

void reset() {
  port.write('f');
  preLaunchButton.setColorBackground(color(0, 0, 0));
  launchButton.setColorBackground(color(0, 0, 0));
  preLaunch = false;
  launch = false;
}

void Initialize() {
  port.write('i');
}

void serialEvent (Serial port) {
  // get the byte
  int inByte = port.read();
  numByte++;
  
  if (inByte == 255) {
    numByte = 0;
  }
  // write to file:
  if (preLaunch && launch && numByte == 2) {
    output.println(str(xPos) + "," + str(force) + "," + str(inByte));
    pressure = height - inByte;
  }
  if (numByte == 2) {
    numByte = 0;
  }
  yPos = height - inByte;
  force = inByte;
}

void draw () {
  stroke(#A8D9A7); //draw in a pretty color
  line(xPos, height, xPos, pressure);
  
  //give a title to window
  fill(0, 0, 0); // text color (r, g, b)
  textFont(font);
  text("Arduino Rocket GUI", 300, 30); //("text", x coordninate, y coordinate)
  
  if (xPos == width) {
    xPos = 0;
    // clear the screen by resetting the background
    background(150, 0, 150);
  } else {
    // increment the horizontal position for the next reading
    xPos++;
  }
   //<>//
  if (ctr == 100) {
    output.flush();
    ctr = 0;
  }
  
  ctr++;
}
