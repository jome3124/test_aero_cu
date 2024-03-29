// ----- Processing code ---------


Scrollbar hs1, hs2;
PImage carImg;//, grdImg;

int count = 0;
int graphPos;
int[] lastGraphPos = new int[3];
int fps = 0;
float motorLimit = 1;

public PIDCtrl ctrl;
Vehicle car;

int rectX, rectY;
int rectSizeX = 300;
int rectSizeY = 110;
color rectColor, circleColor, baseColor;
boolean rectOver = false;
boolean resetOver = false;

String newP="";
String newD="";
String newI="";
String newMass="";
String newDamp="";
String newMax="";

//set up the bounds for the PID boxes and other input boxes
int Px, Py, Dx, Dy, Ix, Iy;
int massX, massY, dampX, dampY, maxFX, maxFY;
int resetX, resetY;
int tSize;
boolean colorSwitch = true;

//set up the booleans for the PID boxes
boolean overProp = false;
boolean propInput = false;
boolean overDer = false;
boolean derInput = false;
boolean overInt = false;
boolean intInput = false;

//set up booleans for the other input boxes
boolean overMass = false;
boolean massInput = false;
boolean overDamp = false;
boolean dampInput = false;
boolean overMax = false;
boolean maxInput = false;


void setup()
{
  //size(1600, 1000, P2D);
  fullScreen();
  textMode(SCREEN);

  noStroke();
  hs1 = new Scrollbar(10, height/4, width/2-width/80, height/35, 1);
  hs2 = new Scrollbar(0, height/15, height/35, 150, 1);
  carImg = loadImage("newtest.png");
 
  ctrl = new PIDCtrl(1, 0, 1);
  car  = new Vehicle(.2, 0.0, radians(0));
  
  background(255);
  
  //set up the buttons
  rectColor = color(200);
  Px = width/2;
  Py = height/20;
  
  rectSizeX = width/9;
  rectSizeY = height/17;
  tSize = rectSizeX/10;
  graphPos = height/3;
  
  Dx = Px+rectSizeX+Py;
  Dy = Py;
  Ix = Px;
  Iy = Py+rectSizeY+Py;
  massX = Dx;
  massY = Iy;
  dampX = Px;
  dampY = Iy+rectSizeY+Py;
  maxFX = Dx;
  maxFY = dampY;
  
  //reset button and change gains button
  rectX = Px;
  rectY = dampY+rectSizeY+Py;
  resetX = Dx;
  resetY = rectY;
  
  newP = "1";
  newD = "1";
  newI = "0";
  newMass = "0.2";
  newDamp = "0";
  newMax = "1";
}

void draw()
{  
  
  update(mouseX, mouseY);
  float carHeight = height/18;

  //100 pixels = 1m
  float carPos = hs1.getPos() / 100.0;
  float error = carPos - car.position;
  float dt = 1.0 / (frameRate+0.000001);
  float force = ctrl.Update(error, dt);
  
  force = max(-motorLimit, min(motorLimit, force));

  car.slope = radians(-hs2.getPos()*.35);
  carPos = car.Update(force, dt) * 100.0;
  
  fill(255);
  stroke(255);
  rect(0,0,width,200);

  pushMatrix();
  translate(width/4,carHeight);
  rotate(car.slope);
  pushMatrix();
  translate(-200, -7);
  scale(70,1);
  //image(grdImg, 0, 0);
  popMatrix();


  translate(carPos-100,carHeight-100);
  image(carImg, 0, 0);

  stroke(200,0,0);
  line(26, 24, 26+ctrl.ComponentP()*10, 24);
  stroke(0,200,0);
  line(26, 26, 26+ctrl.ComponentI()*10, 26);
  stroke(0,0,255);
  line(26, 28, 26+ctrl.ComponentD()*10, 28);
  popMatrix();   

  stroke(230);
  hs1.update();
  hs2.update();
  hs1.display();
  hs2.display();

  if(count%6==0)
    fps = int(frameRate);
  fill(100);
  text(fps+" fps", 5, 15);
  
  
  // graph
  if(count%2==0) {

    stroke(250);
    line(0,graphPos, 40,graphPos);
    stroke(255);
    line(41,graphPos, width/2,graphPos);

    int v;    
    stroke(240);
    point(20,graphPos);
    v = int(force/motorLimit*20)+20;
    if(v==lastGraphPos[2] && (v==0 || v==40))
      stroke(255,150,150);
    else
      stroke(180,250,180);
    line(v, graphPos, lastGraphPos[2], graphPos);
    lastGraphPos[2] = v;


    stroke(150);
    v = int(hs1.getPos()+width/4);
    line(v, graphPos, lastGraphPos[0], graphPos);
    lastGraphPos[0] = v;
  
    v = int(carPos+width/4);
    stroke(50,50,255);
    line(v, graphPos, lastGraphPos[1], graphPos);
    lastGraphPos[1] = v;

  
    graphPos++;
    if(graphPos>=height)
      graphPos=height/3;
  }
  count++;
  
  //change parameters box
  fill(rectColor);
  rect(rectX, rectY, rectSizeX, rectSizeY);
  fill(circleColor);
  textSize(tSize);
  text("Change Parameters", rectX+rectSizeX/40, rectY+rectSizeY/3);
  
  //reset box
  fill(rectColor);
  rect(resetX, resetY, rectSizeX, rectSizeY);
  fill(circleColor);
  textSize(tSize);
  text("Reset", resetX+rectSizeX/40, resetY+rectSizeY/3);
  
  //proportional gain box
  fill(rectColor);
  rect(Px, Py, rectSizeX, rectSizeY);
  fill(circleColor);
  text("Proportional Gain\n"+newP, Px+rectSizeX/40, Py+rectSizeY/3);
  
  //derivative gain box
  fill(rectColor);
  rect(Dx, Dy, rectSizeX, rectSizeY);
  fill(circleColor);
  text("Derivative Gain\n"+newD, Dx+rectSizeX/40, Dy+rectSizeY/3);
  
  //integral gain box
  fill(rectColor);
  rect(Ix, Iy, rectSizeX, rectSizeY);
  fill(circleColor);
  text("Integral Gain\n"+newI, Ix+rectSizeX/40, Iy+rectSizeY/3);
  
  //mass input box
  fill(rectColor);
  rect(massX, massY, rectSizeX, rectSizeY);
  fill(circleColor);
  text("Mass\n"+newMass, massX+rectSizeX/40, massY+rectSizeY/3);
  
  //damping input box
  fill(rectColor);
  rect(dampX, dampY, rectSizeX, rectSizeY);
  fill(circleColor);
  text("Damping (0-1)\n"+newDamp, dampX+rectSizeX/40, dampY+rectSizeY/3);
  
  //max force input box
  fill(rectColor);
  rect(maxFX, maxFY, rectSizeX, rectSizeY);
  fill(circleColor);
  text("Max Force (N)\n"+newMax, maxFX+rectSizeX/40, maxFY+rectSizeY/3);
  
  text("Changes to the parameters on the right will update when you click the update button.\nThe horizontal slider change the position the controller wants to reach.\nThe vertical slider changes the slope to simulate an asymmetrical system.\nRight-clicking on any slider will reset it.\n\nThe graph at the bottom displays system states over time.\nDark grey is the set point, blue is the current position, and green is the motor force.\n\nThe force vectors over the astronaut are the components going into the controller reaction.\nRed is proportional, green is integral, and blue is derivative.\n\nThe motor is a 'super motor' which reaches the desired torque instantly.\nPress the esc key to exit the simulation.", width/2, height/2);
}


void setProcessVars(float p, float i, float d, float mass, float damping, float maxf)
{
  ctrl.Kp=p;
  ctrl.Ki=i;
  ctrl.Kd=d; 
  
  car.mass = mass;
  car.damping = 1.0 - damping;
  motorLimit = maxf;
}

void resetCar()
{
  ctrl.ResetCtrl();
  car.Reset();
}

class PIDCtrl
{
  public float Kp, Ki, Kd;
  float lastError, integError;
  float compP, compI, compD;
  
  PIDCtrl(float p, float i, float d)
  {
    Kp = p;
    Ki = i;
    Kd = d;
    ResetCtrl();
  }
  
  void ResetCtrl()
  {
    lastError = 0.0;
    integError = 0.0;
  }
  
  float Update(float error, float dt)
  {
    integError += error * dt;
    compP = error * Kp;
    compI = integError * Ki;
    compD = ((error - lastError) / dt) * Kd;
    lastError = error;
    return compP + compI + compD;
  }
  
  float ComponentP() {
    return compP;
  }
  float ComponentI() {
    return compI;
  }
  float ComponentD() {
    return compD;
  }
  
}

class Vehicle
{
  public float mass;
  public float position;
  float velocity;
  public float damping;
  public float slope;
  
  Vehicle(float vMass, float vDamping, float vSlope)
  {
    mass = vMass;
    damping = 1.0 - vDamping;
    slope = vSlope;
    Reset();
  }
  
  float Update(float force, float dt)
  { 
    // consider the slope
    force += 9.81 * mass * sin(slope);
  
    // forward euler
    float accel = force / (mass+0.0001);
    velocity += accel * dt;
    velocity *= damping;
    position += velocity * dt;
    return position;
  }

  void Reset()
  {
    position=0;
    velocity=0;
  }  
}



public class Scrollbar
{
  int swidth, sheight;
  int xpos, ypos;
  float spos, newspos;
  int sposMin, sposMax;
  int sposMid;
  boolean over;
  boolean l;
  boolean locked;
  float ratio;

  public Scrollbar (int xp, int yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    ratio = (float)sw / (float)sh;
    xpos = xp;
    ypos = yp-sheight/2;
    if(ratio>=1.0) {
      spos = xpos + swidth/2 - sheight/2;
      sposMin = xpos;
      sposMax = xpos + swidth - sheight;
    }
    else {
      spos = ypos + sheight/2 - swidth/2;
      sposMin = ypos;
      sposMax = ypos + sheight - swidth;
    }
    newspos = spos;
    sposMid = (sposMax+sposMin)/2;
  }

  public void update() {
    if(Over()) {
      over = true;
    } else {
      over = false;
    }
    if(mousePressed && over) {
      if(mouseButton == RIGHT) {
        locked = false;
        spos = sposMid;
      }
      else if(mouseButton == LEFT)
        locked = true;
    }
    if(!mousePressed) {
      locked = false;
    }
    if(locked) {
      if(ratio>1.0) 
        spos = constrain(mouseX-sheight/2, sposMin, sposMax);
      else
        spos = constrain(mouseY-swidth/2, sposMin, sposMax);
    }
  }

  int constrain(int val, int minv, int maxv) {
    return min(max(val, minv), maxv);
  }

  boolean Over() {
    if(mouseX > xpos && mouseX < xpos+swidth &&
    mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    fill(250,160);
    rect(xpos, ypos, swidth, sheight);
    if(over || locked) {
      fill(250, 190, 0);
    } else {
      fill(200);
    }
    if(ratio>1.0)
      rect(spos, ypos, sheight, sheight);
    else
      rect(xpos, spos, swidth, swidth);    
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos - sposMid;
  }
}

void update(int x, int y) {
  if ( overRect(rectX, rectY, rectSizeX, rectSizeY) ) {
    rectOver = true;
  } else {
    rectOver = false;
  }
  if (overProportional(Px, Py, rectSizeX, rectSizeY) ) {
    overProp = true;
  } else {
    overProp = false;
  }
  if (overDerivative(Dx, Dy, rectSizeX, rectSizeY) ) {
    overDer = true;
  } else {
    overDer = false;
  }
  if (overIntegral(Ix, Iy, rectSizeX, rectSizeY) ) {
    overInt = true;
  } else {
    overInt = false;
  }
  if (overMass(massX, massY, rectSizeX, rectSizeY) ) {
    overMass = true;
  } else {
    overMass = false;
  }
  if (overDamp(dampX, dampY, rectSizeX, rectSizeY) ) {
    overDamp = true;
  } else {
    overDamp = false;
  }
  if (overMax(maxFX, maxFY, rectSizeX, rectSizeY) ) {
    overMax = true;
  } else {
    overMax = false;
  }
  if (overReset(resetX, resetY, rectSizeX, rectSizeY) ) {
    resetOver = true;
  } else {
    resetOver = false;
  }
}

void mousePressed() {
  float p = 0;
  float i = 0;
  float d = 100;
  float mass = 0.2;
  float damp = 0;
  float maxF = 1;
  if (rectOver) {
    if(!newP.isEmpty()) {
      p = Float.parseFloat(newP);
    } else {
      p = 0;
    }
    if(!newD.isEmpty()) {
      d = Float.parseFloat(newD);
    } else {
      d = 0;
    }
    if(!newI.isEmpty()) {
      i = Float.parseFloat(newI);
    } else {
      i = 0;
    }
    if(!newMass.isEmpty()) {
      mass = Float.parseFloat(newMass);
    } else {
      mass = 0.2;
    }
    if(!newDamp.isEmpty()) {
      damp = Float.parseFloat(newDamp);
    } else {
      damp = 0;
    }
    if(!newMax.isEmpty()) {
      maxF = Float.parseFloat(newMax);
    } else {
      maxF = 1;
    }
    
    setProcessVars(p, i, d, mass, damp, maxF);
    
    if(colorSwitch) {
      rectColor = 230;
      colorSwitch = false;
    } else {
      rectColor = 200;
      colorSwitch = true;
    }
  }
  if (overProp) {
    propInput = true;
    newP = "";
  } else {
    propInput = false;
  }
  if (overDer) {
    derInput = true;
    newD = "";
  } else {
    derInput = false;
  }
  if (overInt) {
    intInput = true;
    newI = "";
  } else {
    intInput = false;
  }
  if (overMass) {
    massInput = true;
    newMass = "";
  } else {
    massInput = false;
  }
  if (overDamp) {
    dampInput = true;
    newDamp = "";
  } else {
    dampInput = false;
  }
  if (overMax) {
    maxInput = true;
    newMax = "";
  } else {
    maxInput = false;
  }
  if (resetOver) {
    newP = "1";
    newD = "1";
    newI = "0";
    newMass = "0.2";
    newDamp = "0";
    newMax = "1";
    setProcessVars(1.0,0.0,1.0,0.2,0.0,1.0);
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean overProportional(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  } 
}

boolean overDerivative(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  } 
}

boolean overIntegral(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  } 
}

boolean overMass(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  } 
}

boolean overDamp(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  } 
}

boolean overMax(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  } 
}

boolean overReset(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  } 
}

void keyPressed() {
  if(propInput) {
    newP = newP + key;
  }
  if(derInput) {
    newD = newD + key;
  }
  if(intInput) {
    newI = newI + key;
  }
  if(massInput) {
    newMass = newMass + key;
  }
  if(dampInput) {
    newDamp = newDamp + key;
  }
  if(maxInput) {
    newMax = newMax + key;
  }
}



// ----- end of Processing ---------
