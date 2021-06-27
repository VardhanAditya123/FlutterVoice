import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  stt.SpeechToText speech = stt.SpeechToText();
  bool isListen = false;
  String txt = " Press the button and speak";

  // @override
  // void initState(){
  //   super.initState();
  //   speech = stt.SpeechToText();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speech To Text"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListen,
        endRadius: 70.0,
        glowColor: Colors.blue,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: listen,
          child: Icon(isListen ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 150),
          child: Text(txt,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w400,
              )),
        ),
      ),
    );
  }

  void listen() async {
    if (!isListen) {
      bool available = await speech.initialize(
        onStatus: (val) => print('OnStatus: $val $txt '),
        onError: (val) => print('OnError: $val '),
      );
      print(available);

      if (available) {
        setState(() {
          isListen = true;
        });
        speech.listen(
          onResult: (val) => setState(() {
            txt = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() {
        isListen = false;
        speech.stop();
      });
    }
  }
}
