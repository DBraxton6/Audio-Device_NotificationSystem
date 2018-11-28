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

RadioButton batteryStat;
RadioButton networkStat;

Toggle tweetTog;
Toggle callTog;
Toggle emailTog;
Toggle voicemailTog;
Toggle textTog;

boolean trainVal = false;
boolean joggingVal = false;
boolean partyVal = false;
boolean lectureVal = false;
boolean tweetTogVal = false;
boolean callTogVal = false;
boolean emailTogVal = false;
boolean voicemailTogVal = false;
boolean textTogVal = false;
boolean eStream1Val = false;
boolean eStream2Val = false;
boolean eStream3Val = false;




SamplePlayer trainLoop;
SamplePlayer joggingLoop;
SamplePlayer partyLoop;
SamplePlayer lectureLoop;
SamplePlayer tweet;
SamplePlayer text;
SamplePlayer email;
SamplePlayer voicemail;
SamplePlayer call;
SamplePlayer noStat;
SamplePlayer workingStat;
SamplePlayer dyingStat;
SamplePlayer lowStat;
SamplePlayer medStat;
SamplePlayer highStat;

BiquadFilter filter;

//name of a file to load from the data directory
String eventDataJSON1 = "ExampleData_1.json";
String eventDataJSON2 = "ExampleData_2.json";
String eventDataJSON3 = "ExampleData_3.json";

NotificationServer server;
ArrayList<Notification> notifications;

Homework hw;

void setup() {
  size(300, 530);
  ac = new AudioContext(); //ac is defined in helper_functions.pde
  //ac.start();
  p5 = new ControlP5(this);
  
  //context sounds
  trainLoop = getSamplePlayer("train.wav");
  trainLoop.pause(true);
  trainLoop.setToLoopStart();
  trainLoop.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  joggingLoop = getSamplePlayer("city.wav");
  joggingLoop.pause(true);
  joggingLoop.setToLoopStart();
  joggingLoop.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  partyLoop = getSamplePlayer("party.wav");
  partyLoop.pause(true);
  partyLoop.setToLoopStart();
  partyLoop.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  lectureLoop = getSamplePlayer("lecture.wav");
  lectureLoop.pause(true);
  lectureLoop.setToLoopStart();
  lectureLoop.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  
  //notification sounds
  tweet = getSamplePlayer("tweet.wav");
  tweet.pause(true);
  tweet.setToLoopStart();

  text = getSamplePlayer("positive_or_intermediate.mp3");
  text.pause(true);
  text.setToLoopStart();
  
  call = getSamplePlayer("missedCall.wav");
  call.pause(true);
  call.setToLoopStart();
  
  email = getSamplePlayer("email.wav");
  email.pause(true);
  email.setToLoopStart();
  
  voicemail = getSamplePlayer("voicemail.mp3");
  voicemail.pause(true);
  voicemail.setToLoopStart(); 
  
  //status sounds
  noStat = getSamplePlayer("intermediate2.wav");
  noStat.pause(true);
  noStat.setToLoopStart();

  workingStat = getSamplePlayer("positive3.wav");
  workingStat.pause(true);
  workingStat.setToLoopStart();

  dyingStat = getSamplePlayer("negative2.wav");
  dyingStat.pause(true);
  dyingStat.setToLoopStart();  
  
  lowStat = getSamplePlayer("intermediate1.wav");
  lowStat.pause(true);
  lowStat.setToLoopStart();
  
  medStat = getSamplePlayer("positive1.wav");
  medStat.pause(true);
  medStat.setToLoopStart();
  
  highStat = getSamplePlayer("positive2.wav");
  highStat.pause(true);
  highStat.setToLoopStart();  
  
  //this will create WAV files in your data directory from input speech 
  //which you will then need to hook up to SamplePlayer Beads
  ttsMaker = new TextToSpeechMaker();

  
  //String exampleSpeech0 = "JOGGING";
  
  
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
  gain.addInput(tweet); 
  gain.addInput(text); 
  gain.addInput(email); 
  gain.addInput(call); 
  gain.addInput(voicemail);
  gain.addInput(noStat); 
  gain.addInput(workingStat); 
  gain.addInput(dyingStat); 
  gain.addInput(lowStat); 
  gain.addInput(medStat); 
  gain.addInput(highStat); 
  
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
    .setPosition(75, 485)
    .setSize(50, 30)
    .activateBy((ControlP5.RELEASE))
    .setLabel("Stream 1");  

   eventStream2 = p5.addButton("eStream2")
    .setPosition(125, 485)
    .setSize(50, 30)
    .activateBy((ControlP5.RELEASE))
    .setLabel("Stream 2");  
    
   eventStream3 = p5.addButton("eStream3")
    .setPosition(175, 485)
    .setSize(50, 30)
    .activateBy((ControlP5.RELEASE))
    .setLabel("Stream 3");
    
   status = p5.addButton("workingStatus")
    .setPosition(122.5, 415)
    .setSize(50, 30)
    .activateBy((ControlP5.RELEASE))
    .setLabel("Status");    
    
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

   batteryStat = p5.addRadioButton("batteryStatus")
     .setPosition(55, 325)
     .setSize(20, 20)
     .setSpacingColumn(30)
     .setItemsPerRow(4)
     .addItem("Dying", 1)
     .addItem("Low", 2)
     .addItem("Med", 3)
     .addItem("High", 4);
     
   networkStat = p5.addRadioButton("networkStatus")
     .setPosition(75, 375)
     .setSize(20, 20)
     .setSpacingColumn(30)
     .setItemsPerRow(3)
     .addItem("Poor", 1)
     .addItem("Okay", 2)
     .addItem("Strong", 3);     
     
     ac.out.addInput(gain);
     ac.start();
}

void draw() {
  background(256);
  text("Select a contex:", 105, 22.5);
  text("Toggle Notifications:", 90, 135);
  text("Batter Status:", 110, 317.5);
  text("Network Status:", 110, 367.5);
  text("Select an event stream:",80, 477.5);


}

void keyPressed() {
  //example of stopping the current event stream and loading the second on
    
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
        tweetHandler();
        break;
      case Email:
        debugOutput += "New email from ";
        emailHandler();
        break;
      case VoiceMail:
        debugOutput += "New voicemail from ";
        voicemailHandler();
        break;
      case MissedCall:
        debugOutput += "Missed call from ";
        callHandler();
        break;
      case TextMessage:
        debugOutput += "New message from ";
        textHandler();
        break;
    }
    debugOutput += notification.getSender() + ", " + notification.getMessage();
    ttsExamplePlayback(debugOutput); //see ttsExamplePlayback below for usage    
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
  //sp.pause(true);
  sp.start();
  //println("TTS: " + inputSpeech);
}


public void play(SamplePlayer sp){
  sp.setToLoopStart();
  sp.start();
}

void train() {
  println("**** New context: TRAIN ****");
  trainVal = true;
  joggingVal = false;
  partyVal = false;
  lectureVal = false;
  joggingLoop.pause(true);
  partyLoop.pause(true);
  lectureLoop.pause(true);
  play(trainLoop);
  
}

void jogging() {
  println("**** New context: JOGGING ****");
  trainVal = false;
  joggingVal = true;
  partyVal = false;
  lectureVal = false;
  trainLoop.pause(true);
  joggingLoop.pause(true);
  partyLoop.pause(true);
  play(joggingLoop);
}

void party() {
  println("**** New context: PARTY ****");
  trainVal = false;
  joggingVal = false;
  partyVal = true;
  lectureVal = false;  
  trainLoop.pause(true);
  joggingLoop.pause(true);
  lectureLoop.pause(true);
  partyLoop.start();
}

void lecture() {
  println("**** New context: LECTURE ****"); 
  trainVal = false;
  joggingVal = false;
  partyVal = false;
  lectureVal = true;  
  trainLoop.pause(true);
  joggingLoop.pause(true);
  partyLoop.pause(true);
  lectureLoop.start();
}

void batteryStatus(int x) {
  if (x == 1 && joggingVal == true)
    ttsExamplePlayback("Battery Level Critical"); //see ttsExamplePlayback below for usage
  else if(x == 1)
    play(lowStat);
  else if (x == 2)
    play(lowStat);
  else if (x == 3)
    play(medStat);
  else
    play(highStat);
}

void networkStatus(int x) {
  if(x == 1)
    play(lowStat);
  else if (x == 2)
    play(medStat);
  else
    play(highStat);  
}

void workingStatus() {
  if(eStream1Val == false && eStream2Val == false && eStream3Val == false)
    play(noStat);
  else
    play(workingStat);
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

void textHandler() {
  if(textTogVal == false) {
    text.pause(true);
  } 
  else {
    play(text);
  }
}

void tweetHandler() {
  if(tweetTogVal == false) {
    tweet.pause(true);  
  } 
  else {
    play(tweet);
  }
}

void emailHandler() {
  if(emailTogVal == false) {
    email.pause(true);  
  } 
  else {
    play(email);
  }
}

void callHandler() {
  if(callTogVal == false) {
    call.pause(true);  
  }
  else {
    play(call);
  }
}

void voicemailHandler() {
  if(voicemailTogVal == false) {
    voicemail.pause(true);
  } 
  else
    play(voicemail);
}

void eStream1() {
  //loading the event stream, which also starts the timer serving events
  server.stopEventStream();
  server.loadEventStream(eventDataJSON1);
  println("**** New event stream loaded: " + eventDataJSON1 + " ****");
  eStream1Val = true;
  eStream2Val = false;
  eStream3Val = false;
  
}

void eStream2() {
  server.stopEventStream();
  server.loadEventStream(eventDataJSON2);
  println("**** New event stream loaded: " + eventDataJSON2 + " ****");  
  eStream2Val = true;
  eStream1Val = false;
  eStream3Val = false;
}

void eStream3() {
  server.stopEventStream();
  server.loadEventStream(eventDataJSON3);
  println("**** New event stream loaded: " + eventDataJSON3 + " ****");  
  eStream3Val = true;
  eStream1Val = false;
  eStream2Val = false;
}
