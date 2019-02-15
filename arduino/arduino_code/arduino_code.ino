void setup() {

  pinMode(10, OUTPUT); //set pin as output, blue led
  pinMode(11, OUTPUT); //set pin as output, red led

  Serial.begin(9600);  //start serial communication rate

}

bool preLaunch = false;
bool launch = false;
byte msg[6];

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
    }

    if(val == 'f') {
      digitalWrite(10, LOW);
      digitalWrite(11, LOW);
      preLaunch = false;
      launch = false;
    }

    if(val == 'i') {
      Serial.write(255);
    }

  }

  int force = analogRead(A0)/4; //divide by 4 to reduce range to 0-255
  int pressure = analogRead(A1)/4; //reduce range to 0-255
  /*Serial.write(force);
  delay(5);
  Serial.write(pressure);
  delay(15);*/

  long time = 123456;
  msg[0] = time/1000/60;
  msg[1] = (time - msg[0]*1000*60) / 1000;
  msg[2] = (time - msg[0]*1000*60 - msg[1]*1000) / 4;
  msg[3] = 254;
  msg[4] = pressure;
  msg[5] = 255;
  Serial.write(msg, 6);
  
  delay(20);
  
}

