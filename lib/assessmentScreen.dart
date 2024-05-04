import 'dart:convert';
import 'dart:math';


import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import "package:dancewell/models/videos.dart";


// The AssessmentPage widget: A StatefulWidget that takes responses and an organ as input.
class AssessmentPage extends StatefulWidget {
  const AssessmentPage({
    Key? key,
    required this.responses,
    required this.organ,
  }) : super(key: key);
  final List responses;
  final String organ;


  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}


class _AssessmentPageState extends State<AssessmentPage> {
  // Initialization of a generative model with an API key.
  final model = GenerativeModel(
      model: 'gemini-pro', apiKey: dotenv.env['OPENAI_API_KEY']!);
  String? result;


  // initState method: Called when this object is inserted into the tree.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    geminiFunctionCalling();
  }


  // saveAssessment method: Saves the assessment result into local storage.
  Future<void> saveAssessment() async {
    Map<String, dynamic> assessmentMap = {};
    String key = 'assessment';
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm a');
    String formattedDate = formatter.format(now);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve any existing assessment data.
    if (prefs.containsKey(key)) {
      assessmentMap = jsonDecode(prefs.getString(key)!);
    }


    // Update the assessment map with new data and save it.
    assessmentMap[formattedDate] = {'organ': widget.organ, 'result': result};


    String info = jsonEncode(assessmentMap);
    await prefs.setString(key, info);
    print(prefs.getString(key)!);
  }


  // geminiFunctionCalling method: Communicates with the Gemini model and sets the response.
  Future<void> geminiFunctionCalling() async {
    // Start a chat with the generative AI model and send a message.
    final chat = model.startChat(history: [
      Content.text(
          'These are the response for the questions: ${widget.responses}'),
      Content.model([TextPart('Hello, How can I help you?')]),
    ]);


    // Ask AI to assess and give advice
    var message =
        'act as a doctor specifically for dancers. Provide an assessment of my symptoms and give me some advices';
    var content = Content.text(message);
    final response = await chat.sendMessage(content);


    // Update the result state with the model's response.
    setState(() {
      result = response.text;
    });
  }


  // build method: Describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press by saving the assessment and navigating back.
        saveAssessment();
        Navigator.pop(context);
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        // Floating action button: Opens a bottom sheet with a YouTube player for a video.
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.play_arrow),
            onPressed: () async {
              var randomVideoIndex =
              Random().nextInt(videos[widget.organ]!.length);
              YoutubePlayerController _controller = YoutubePlayerController(
                initialVideoId: videos[widget.organ]![randomVideoIndex],
                flags: YoutubePlayerFlags(
                  autoPlay: true,
                  mute: true,
                ),
              );


              // Show modal bottom sheet with a YouTube player.
              await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.purple,
                      progressColors: const ProgressBarColors(
                        playedColor: Colors.purple,
                        handleColor: Colors.purpleAccent,
                      ),
                    );
                  });
            },
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('DanceWell', style: TextStyle(color: Colors.black)),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          // Body: If the result is available, display it inside a Markdown widget for formatted text.
          // Otherwise, show a loading indicator.
          body: result != null
              ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                MarkdownBody(
                  data: result!,
                ),
              ],
            ),
          )
              : const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            ),
          )),
    );
  }
}
