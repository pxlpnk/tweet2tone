import processing.serial.*;

int       baud          =    9600;
String    twitterUsr    =    "xxxx";
String    twitterPass   =    "xxxx";
int       sleepTime     =    60000;            //    wait 60 sec before looking for a new tweet
int       fps           =    1;
Twitter myTwitter;
Serial myPort;

String    lastTweet;


void setup() {
    frameRate(fps);
    //println(Serial.list());
    lastTweet = "";
};


void draw()
{
    //    catch tweet and send tweet to Arduino
    String ardMsg = catchTweets();
    println(ardMsg);
    //    if this tweet differs to the last one --> send it to Arduino
    if (ardMsg != lastTweet)
    {
        send2ard(ardMsg);
        lastTweet = ardMsg;
        
        //    wait a while
        delay(sleepTime);
    }
}


String catchTweets()
{
    myTwitter     =    new Twitter(twitterUsr, twitterPass);
    myPort        =    new Serial(this, Serial.list()[0], baud);
    String ardMsg = " ";
    
    //    TODO:    documentation
    Query query = new Query("#hs");
    
    try {
        //    get just the last tweet
        query.setRpp(1);
        QueryResult result = myTwitter.search(query);
        //    after sending the search query it crashes when you don't have an internet connection... that SHOULD be improved!!! :)
        ArrayList tweets = (ArrayList) result.getTweets();
        Tweet t = (Tweet) tweets.get(0);
        
        //    start buildung the string we want to send to the little arduino boy
        String user = t.getFromUser();
        String msg = t.getText();
        Date tweeteDate = t.getCreatedAt();
        println("Tweet by " + user + " at " + tweeteDate + ": " + msg);
        ardMsg = user + "   :" + tweeteDate + ":" + msg;
     }
     catch (TwitterException te)
     {
         println("Couldn't connect: " + te);
     };
     
     return ardMsg;
}


void send2ard(String msg)
{
    for (int i = 0; i < msg.length(); i++)
    {
          try
          {
              myPort.write(msg.charAt(i));
          }
          catch (Exception ae) {
              println("Couldn't send to Arduino: " + ae);
          }
      }
}
