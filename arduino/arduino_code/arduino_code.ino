void setup() {

  pinMode(10, OUTPUT); //set pin as output, blue led
  pinMode(11, OUTPUT); //set pin as output, red led

  Serial.begin(9600);  //start serial communication rate

}

bool preLaunch = false;
bool launch = false;
byte msg[2];

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

  msg[0] = force;
  msg[1] = pressure;
  Serial.write(msg, 2);
  
  delay(10);
  
}

