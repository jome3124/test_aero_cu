void setup() {

  pinMode(10, OUTPUT); //set pin as output, blue led
  pinMode(11, OUTPUT); //set pin as output, red led

  Serial.begin(9600);  //start serial communication rate

}

bool preLaunch = false;
bool launch = false;
int k = 0;
int offset = 0;
byte thrust[10000];
byte pressure[10000];
byte time1[10000];
byte time2[10000];
byte time3[10000];
byte check[10000];
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
        offset += analogRead(A2)/4; // divide by 4 to reduce range to 0-255
        delay(10);
      }
      analogWrite(DAC0, floor(offset/25)+5); //output the appropriate average offset value
    }

  }

  if (launch == true) {
    int force = analogRead(A0)/4; //divide by 4 to reduce range to 0-255
    int onePressure = analogRead(A1)/4; //reduce range to 0-255

    long time = millis()+65536;
    time1[k] = time;
    time2[k] = time >> 8;
    time3[k] = time >> 16;
    thrust[k] = force;
    pressure[k] = onePressure;
    check[k] = 255;
    //Serial.write(msg, 6);
    k++;
    delay(1);

    if (k == 500) { //wait .5 seconds before sending the fire command
      digitalWrite(12, HIGH); //write pin 12 as high to trigger the launch
    }

    if (k == 2000) { // the firing is over, set booleans to false to disarm the system
      preLaunch = false;
      launch = false;

      //after system is disarmed, send the data over serial to matlab
      for(int j = 0; j<=k; j++) {
        msg[0] = time1[j];
        msg[1] = time2[j];
        msg[2] = time3[j];
        msg[3] = thrust[j];
        msg[4] = pressure[j];
        msg[5] = check[j];
        Serial.write(msg, 6);
        delay(10);
      }
    }
  }
}
