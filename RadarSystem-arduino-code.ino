#include <Servo.h>

Servo myServo;
const int trigPin = 9;
const int echoPin = 10;
const int buzzer = 8; // Buzzer pin

void setup() {
  myServo.attach(6);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(buzzer, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  for (int angle = 0; angle <= 180; angle += 10) {
    myServo.write(angle);
    delay(150);

    // Measure distance
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);

    long duration = pulseIn(echoPin, HIGH);
    long distance = duration / 58; // cm

    // Buzzer if object is closer than 20 cm
    if (distance < 20 && distance > 0) digitalWrite(buzzer, HIGH);
    else digitalWrite(buzzer, LOW);

    // Send data to Processing as "angle,distance"
    Serial.print(angle);
    Serial.print(",");
    Serial.println(distance);
  }
}








