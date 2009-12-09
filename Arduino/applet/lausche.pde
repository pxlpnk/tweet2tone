int baud = 9600;
char incomingByte = 0;
char incomingChar[200];
int counter = 0;

void setup()
{
  Serial.begin(baud);
}

void loop()
{
  
  if (Serial.available() > 0)
  {
    counter++;
    incomingChar[counter] = Serial.read();    
  }
  
  for (int i = 0; i <= counter; i++)
  {
    Serial.print("read: ");
    Serial.println(incomingChar[i]);
  }
}