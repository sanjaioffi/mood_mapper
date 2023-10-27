import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_tracker/app_colors.dart';
import 'package:mood_tracker/screens/mood_screen.dart';
import 'package:speech_to_text/speech_to_text.dart';

class sttPage extends StatefulWidget {
  const sttPage({super.key});

  @override
  State<sttPage> createState() => _sttPageState();
}

class _sttPageState extends State<sttPage> {
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
        onResult: _onSpeechResult, sampleRate: 160000000);
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              _speechToText.isListening
                  ? "listening..."
                  : _speechEnabled
                      ? "Tap the microphone to start listening..."
                      : "Speech not available",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Container(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Text(
                _wordsSpoken,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 50,
          ),
          FloatingActionButton(
            onPressed:
                _speechToText.isListening ? _stopListening : _startListening,
            tooltip: 'Listen',
            child: Icon(
              _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
          ),
          _wordsSpoken == ''
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: () => Get.to(MoodScreen(_wordsSpoken)),
                    tooltip: 'Listen',
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    backgroundColor: AppColor.whatsAppTealGreen,
                  ),
                ),
        ],
      ),
    );
  }
}
