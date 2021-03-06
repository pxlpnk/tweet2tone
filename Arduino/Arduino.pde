#define  tweetSize  200            //  how many chars are in one tweet
#define  baud       9600           //  baud for serial connection
#define beatCount   3*tweetSize    //  this defines the music array: tone, octave, duration, tone, octave, duration, tone, octave, duration

int   speakerPin    =  13;
char  incomingByte  =  0;
char  incomingChar[tweetSize];
int   counter       =  0;

char  beat[beatCount];


void setup()
{
  Serial.begin(baud);
  for (int i = 0; i < beatCount; i++)
  {
    //  fill the melody array with zeros --> nothing will be played
    beat[i] = 0;
  }
}


void loop()
{
  boolean newTweet = false;
  while (Serial.available() > 0)
  {
    //  get one complete tweet once in a time
    counter++;
    incomingChar[counter] = getTweet();
    newTweet = true;
  }
  
  if (newTweet)
  {
    //  we have a new tweet, jeah jeah play play
    for (int i = 0; i < tweetSize; i++)
    {
      parseTweet(incomingChar, i);
    }
  
    //  make the music stuff
    tweet2tone();
  
    //  reset counter for the next tweet
    counter = 0;
  }
}


//  catch one char from from the serial port
char getTweet()
{
  //  maybe we have to cache some tweets here?
  //  maybe write a own short protocoll here?
  char tweetChar =  Serial.read();

  return tweetChar;
}


//  wicked switch case to parse the tweet
void parseTweet(char tweet[tweetSize], int i)
{
  switch(tweet[i])
  {
    case 1:
    //  normal letter/number
    //  just a dummy to show what needs to be done here!
      char tone    = int("a");
      int octave   = 3;
      int duration = 1;
      beat[i*3]    =  tone;
      beat[i*3+1]  =  octave;
      beat[i*3+2]  =  duration;
    break;
  }

}

//  let's make some music for each entry in beat[]
void tweet2tone()
{
  //  start the music now
  for (int i = 0; i < beatCount; i+=3)
  {
    int tone = generateTone(beat[i], beat[i+1]);
    playTone(tone, beat[i+2]);
  }
}


//  merges tone + octave
int generateTone(int tone, int octave)
{
  //  TODO:  merge tone with octave
  return 1136;
}


//  make a beep
void playTone(int tone, int duration) {
  for (long i = 0; i < duration * 1000L; i += tone * 2) {
    digitalWrite(speakerPin, HIGH);
    delayMicroseconds(tone);
    digitalWrite(speakerPin, LOW);
    delayMicroseconds(tone);
  }
}
