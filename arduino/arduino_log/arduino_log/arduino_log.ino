 void setup() {

  pinMode(10, OUTPUT); //set pin as output, blue led
  pinMode(11, OUTPUT); //set pin as output, red led

  Serial.begin(9600);  //start serial communication rate

}

bool preLaunch = false;
bool launch = true;
int k = 0;
int offset = 0;
double thrust;
String out;

void loop() {

  if(Serial.available()) {  //id data is available to read

    char val = Serial.read();

    if(val == 'b') {   //if b is received
      digitalWrite(10, HIGH); //turn on blue led
      preLaunch == true;
    }
    
    if(val == 'r') {   //if r is received
      digitalWrite(11, HIGH); //turn on red led
      launch = true;
      k=0;
    }

    if(val == 'f') {
      digitalWrite(10, LOW);
      digitalWrite(11, LOW);
      preLaunch = false;
      launch = false;
    }

    if(val == 'z') {
      offset = 0;
      for(int k = 0; k<25; k++) {
        offset += analogRead(A2)/4; // divide by 4 to reduce range to 0-255, this is to arduino zero
        delay(2);
      }
      analogWrite(DAC0, floor(offset/25)+25); //output the appropriate average offset value, this is from arduino zero
    }

  }

  if (launch == true) {
    digitalWrite(13, true); //write digital io pin 13 to true.  This will trip a transistor to ignite the rocket
    
    int force = analogRead(A0)/4; //divide by 4 to reduce range to 0-255, is the output from the load cell

    //convert to correct units
    thrust = force * (3.3/(0.1*10*5/25)) / 255;
    
    //write the data at each timestep to the serial monitor, thereby writing it to the sd card
    out = String(String(thrust, 3) + ", " + millis());
    Serial.println(out);

  }
}
