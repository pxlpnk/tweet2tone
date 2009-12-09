import processing.serial.*;

Twitter myTwitter;
int countTweets = 100;
Serial myPort;
int baud = 9600;

void setup() {
  myTwitter = new Twitter("opentu", "derdepadde");
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], baud);
  try {

    Query query = new Query("#hs");
    query.setRpp(countTweets);
    QueryResult result = myTwitter.search(query);

    ArrayList tweets = (ArrayList) result.getTweets();

    for (int i = 0; i < tweets.size(); i++) {
      Tweet t = (Tweet) tweets.get(i);
      String user = t.getFromUser();
      String msg = t.getText();
      Date tweeteDate = t.getCreatedAt();
      println("Tweet by " + user + " at " + tweeteDate + ": " + msg);
      String ardMsg = user + "   :" + tweeteDate + ":" + msg;
      send2ard(ardMsg);
    };

  }
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  };
};


void send2ard(String msg) {
    for (int i = 0; i < msg.length(); i++) {
          try {
              myPort.write(msg.charAt(i));
          }
          catch (Exception ae) {
              println("Couldn't send to Arduino: " + ae);
          }
      }
}


