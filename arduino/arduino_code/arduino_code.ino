void setup() {

  pinMode(10, OUTPUT); //set pin as output, blue led
  pinMode(11, OUTPUT); //set pin as output, red led

  Serial.begin(9600);  //start serial communication rate

}

bool preLaunch = false;
bool launch = false;
byte msg[6];
int ctr = 1;
int R1 = 122; // [ohm]
int R2 = 122; // [ohm]
int v_strain, v_ref, v_press, r_strain, r_press; // [V], [ohm]
int R4 = 122; // [ohm]

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

  
  if(val == 's') {
  v_strain = analogRead(A0) * 3.3/1024;
  v_ref = analogRead(A1) * 3.3/1024;
  v_press = analogRead(A2) * 3.3/1024;

  //compute the resistance of the strain gauge
  r_strain = ((R4*v_strain/v_ref) + (R2*R4/(R1+R2))) / (1-v_strain/v_ref-R2/(R1+R2));
  r_press = v_press / 3.3 * 255;
  //r_strain = 69;
  //r_press = 169;

  long time = millis()+65536;
  msg[0] = time;
  msg[1] = time >> 8;
  msg[2] = time >> 16;
  msg[3] = r_strain;
  msg[4] = r_press;
  //msg[5] = v_press;
  msg[5] = 255;
  //msg[7] = 255;
  Serial.write(msg, 6);
  
  delay(5);
  }
  }
}

