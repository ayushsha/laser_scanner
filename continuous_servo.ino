

#include <Servo.h> 

Servo myservo;
int incoming;


void setup() 
{ 
  myservo.attach(9);
  Serial.begin(9600); 
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);
  digitalWrite(12, LOW);
  digitalWrite(13, LOW);
} 


void loop() 
{
  if(Serial.available()>0)
  {
    incoming=Serial.read();
    if(incoming==48)
    {
      digitalWrite(13, HIGH);
      while(Serial.available()<=0)
      {
        myservo.write(91);
        delay(20);
        myservo.write(93);
        delay(20);
      }
      incoming=Serial.read();
      if(incoming==49)
      {
        digitalWrite(13, LOW);
        myservo.write(93);
      }
    }
  }
} 




