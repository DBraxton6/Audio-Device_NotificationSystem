import beads.*;
import org.jaudiolibs.beads.*;
import controlP5.*;

TextToSpeechMaker ttsMaker; 

ControlP5 p5;
Gain gain;

Button train;
Button jogging;
Button party;
Button lecture;
Button status;
Button eventStream1;
Button eventStream2;
Button eventStream3;
//radios for battery status
//radios network connection

Toggle tweetTog;
Toggle callTog;
Toggle emailTog;
Toggle voicemailTog;
Toggle textTog;

boolean tweetTogVal = false;
boolean callTogVal = false;
boolean emailTogVal = false;
boolean voicemailTogVal = false;
boolean textTogVal = false;


SamplePlayer trainLoop;
SamplePlayer joggingLoop;
SamplePlayer partyLoop;
SamplePlayer lectureLoop;

BiquadFilter filter;

//name of a file to load from the data directory
String eventDataJSON1 = "ExampleData_1.json";
String eventDataJSON2 = "ExampleData_2.json";
String eventDataJSON3 = "ExampleData_3.json";

NotificationServer server;
ArrayList<Notification> notifications;

Homework hw;

void setup() {
  size(300, 600);
  ac = new AudioContext(); //ac is defined in helper_functions.pde
  //ac.start();
  p5 = new ControlP5(this);
  
  trainLoop = getSamplePlayer("intermission.wav");
  trainLoop.pause(true);
  trainLoop.setToLoopStart();
  trainLoop.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  joggingLoop = getSamplePlayer("voice1.wav");
  joggingLoop.pause(true);
  joggingLoop.setToLoopStart();
  joggingLoop.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  partyLoop = getSamplePlayer("voice2.wav");
  partyLoop.pause(true);
  partyLoop.setToLoopStart();
  partyLoop.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  lectureLoop = getSamplePlayer("intermission.wav");
  lectureLoop.pause(true);
  lectureLoop.setToLoopStart();
  lectureLoop.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  
  
  //this will create WAV files in your data directory from input speech 
  //which you will then need to hook up to SamplePlayer Beads
  ttsMaker = new TextToSpeechMaker();
  
  String exampleSpeech0 = "JOGGING";
  
  ttsExamplePlayback(exampleSpeech0); //see ttsExamplePlayback below for usage
  
  //START NotificationServer setup
  server = new NotificationServer();
  
  //instantiating a custom class (seen below) and registering it as a listener to the server
  hw = new Homework();
  server.addListener(hw);
  
  //END NotificationServer setup
  
  gain = new Gain(ac, 1);
  gain.addInput(trainLoop);
  gain.addInput(joggingLoop);
  gain.addInput(partyLoop);
  gain.addInput(lectureLoop);  
  //BUTTONS SETUP
  
  //contexts
  train = p5.addButton("train")
    .setPosition(95, 30)
    .setSize(50, 30)
    .activateBy((ControlP5.RELEASE))
    .setLabel("Train");
    
   jogging = p5.addButton("jogging")
    .setPosition(155, 30)
    .setSize(50, 30)
    .activateBy((ControlP5.RELEASE))
    .setLabel("Jogging");
    
   party = p5.addButton("party")
    .setPosition(95, 65)
    .setSize(50, 30)
    .activateBy((ControlP5.RELEASE))
    .setLabel("Party");
    
   lecture = p5.addButton("lecture")
    .setPosition(155, 65)
    .setSize(50, 30)
    .activateBy((ControlP5.RELEASE))
    .setLabel("Lecture");

  //event streams
   eventStream1 = p5.addButton("eStream1")
    .setPosition(75, 500)
    .setSize(50, 30)
    .activateBy((ControlP5.RELEASE))
    .setLabel("Stream 1");  

   eventStream2 = p5.addButton("eStream2")
    .setPosition(125, 500)
    .setSize(50, 30)
    .activateBy((ControlP5.RELEASE))
    .setLabel("Stream 2");  
    
   eventStream3 = p5.addButton("eStream3")
    .setPosition(175, 500)
    .setSize(50, 30)
    .activateBy((ControlP5.RELEASE))
    .setLabel("Stream 3");  
    
   //notifications 
   tweetTog = p5.addToggle("tweetToggle")
     .setPosition(95, 142.5)
     .setSize(50, 30)
     .setLabel("Tweets");
     
   callTog = p5.addToggle("callToggle")
     .setPosition(150, 142.5)
     .setSize(50, 30)
     .setLabel("Missed Call");
     
   emailTog = p5.addToggle("emailToggle")
     .setPosition(95, 187.5)
     .setSize(50, 30)
     .setLabel("Email");
     
   voicemailTog = p5.addToggle("voicemailToggle")
     .setPosition(150, 187.5)
     .setSize(50, 30)
     .setLabel("Voicemail");
     
   textTog = p5.addToggle("textToggle")
     .setPosition(122.5, 232.5)
     .setSize(50, 30)
     .setLabel("Texts");
     
     ac.out.addInput(gain);
     ac.start();
}

void draw() {
  background(256);
  text("Select a contex:", 105, 22.5);
  text("Toggle Notifications:", 90, 135);
  text("Select an event stream:",80, 495);


}

void keyPressed() {
  //example of stopping the current event stream and loading the second one
  if (key == RETURN || key == ENTER) {
    server.stopEventStream(); //always call this before loading a new stream
    server.loadEventStream(eventDataJSON2);
    println("**** New event stream loaded: " + eventDataJSON2 + " ****");
  }
    
}

//in your own custom class, you will implement the NotificationListener interface 
//(with the notificationReceived() method) to receive Notification events as they come in
class Homework implements NotificationListener {
  
  public Homework() {
    //setup here
  }
  
  //this method must be implemented to receive notifications
  public void notificationReceived(Notification notification) { 
    println("<Example> " + notification.getType().toString() + " notification received at " 
    + Integer.toString(notification.getTimestamp()) + "millis.");
    
    String debugOutput = "";
    switch (notification.getType()) {
      case Tweet:
        debugOutput += "New tweet from ";
        break;
      case Email:
        debugOutput += "New email from ";
        break;
      case VoiceMail:
        debugOutput += "New voicemail from ";
        break;
      case MissedCall:
        debugOutput += "Missed call from ";
        break;
      case TextMessage:
        debugOutput += "New message from ";
        break;
    }
    debugOutput += notification.getSender() + ", " + notification.getMessage();
    
    println(debugOutput);
    
   //You can experiment with the timing by altering the timestamp values (in ms) in the exampleData.json file
    //(located in the data directory)
  }
}

void ttsExamplePlayback(String inputSpeech) {
  //create TTS file and play it back immediately
  //the SamplePlayer will remove itself when it is finished in this case
  
  String ttsFilePath = ttsMaker.createTTSWavFile(inputSpeech);
  println("File createdi at " + ttsFilePath);
  
  //createTTSWavFile makes a new WAV file of name ttsX.wav, where X is a unique integer
  //it returns the path relative to the sketch's data directory to the wav file
  
  //see helper_functions.pde for actual loading of the WAV file into a SamplePlayer
  
  SamplePlayer sp = getSamplePlayer(ttsFilePath, true); 
  //true means it will delete itself when it is finished playing
  //you may or may not want this behavior!
  
  ac.out.addInput(sp);
  sp.setToLoopStart();
  sp.start();
  println("TTS: " + inputSpeech);
}


public void play(SamplePlayer sp){
  sp.setToLoopStart();
  sp.start();
}

void train() {
  println("**** New context: TRAIN ****");
  joggingLoop.pause(true);
  partyLoop.pause(true);
  lectureLoop.pause(true);
  play(trainLoop);
  
}

void jogging() {
  println("**** New context: JOGGING ****");
  trainLoop.pause(true);
  joggingLoop.pause(true);
  partyLoop.pause(true);
  play(joggingLoop);
}

void party() {
  println("**** New context: PARTY ****");
  trainLoop.pause(true);
  joggingLoop.pause(true);
  lectureLoop.pause(true);
  partyLoop.start();
}

void lecture() {
  println("**** New context: LECTURE ****"); 
  trainLoop.pause(true);
  joggingLoop.pause(true);
  partyLoop.pause(true);
  lectureLoop.start();
}

void tweetToggle() {
  if(!tweetTogVal)
    tweetTogVal = true;
  else
    tweetTogVal = false;
}

void callToggle() {
  if(!callTogVal)
    callTogVal = true;
  else
    callTogVal = false;     
}

void emailToggle() {
  if(!emailTogVal)
    emailTogVal = true;
  else
    emailTogVal = false;     
}

void voicemailToggle() {
  if(!voicemailTogVal)
    voicemailTogVal = true;
  else
    voicemailTogVal = false;     
}

void textToggle() {
  if(!textTogVal)
    textTogVal = true;
  else
    textTogVal = false;     
}

void eStream1() {
  //loading the event stream, which also starts the timer serving events
  server.stopEventStream();
  server.loadEventStream(eventDataJSON1);
  println("**** New event stream loaded: " + eventDataJSON1 + " ****");
  
}

void eStream2() {
  server.stopEventStream();
  server.loadEventStream(eventDataJSON2);
  println("**** New event stream loaded: " + eventDataJSON2 + " ****");  
}

void eStream3() {
  server.stopEventStream();
  server.loadEventStream(eventDataJSON3);
  println("**** New event stream loaded: " + eventDataJSON3 + " ****");  
}
