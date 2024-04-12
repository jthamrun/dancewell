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
  final model = GenerativeModel(
      model: 'gemini-pro', apiKey: dotenv.env['OPENAI_API_KEY']!);
  String? result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*
    _openAI = OpenAI.instance.build(
      token: dotenv.env['OPENAI_API_KEY'],
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    */

    geminiFunctionCalling();
  }

  Future<void> saveAssessment() async {
    Map<String, dynamic> assessmentMap = {};
    String key = 'assessment';
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm a');
    String formattedDate = formatter.format(now);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      assessmentMap = jsonDecode(prefs.getString(key)!);
    }
    assessmentMap[formattedDate] = {'organ': widget.organ, 'result': result};

    String info = jsonEncode(assessmentMap);
    await prefs.setString(key, info);
    print(prefs.getString(key)!);
  }

  ///parameter name is require
  /*
  void gptFunctionCalling() async {
    String systemPrompt =
        'act as a doctor. Provide an assessment of my symptoms and give me some advices';
    String userPrompt =
        'These are the response for the questions: ${widget.responses}';
    final request = ChatCompleteText(
      messages: [
        Messages(
          role: Role.system,
          content: systemPrompt,
        ),
        Messages(
          role: Role.user,
          content: userPrompt,
        ),
      ],
      maxToken: 2000,
      model: GptTurbo0631Model(),
    );

    ChatCTResponse? response = await gemini.onChatCompletion(request: request);
    for (var element in response!.choices) {
      String? message = element.message?.content;
      // print(stringList);
      setState(() {
        result = message!;
      });
    }
  }
*/

  Future<void> geminiFunctionCalling() async {
    final chat = model.startChat(history: [
      Content.text(
          'These are the response for the questions: ${widget.responses}'),
      Content.model([TextPart('Hello, How can I help you?')]),
    ]);

    var message =
        'act as a doctor. Provide an assessment of my symptoms and give me some advices';
    var content = Content.text(message);
    final response = await chat.sendMessage(content);

    setState(() {
      result = response.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //Pop until Home page
        saveAssessment();
        Navigator.pop(context);
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
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
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: const Color.fromRGBO(183, 76, 174, 1.0),
            toolbarHeight: 100,
            // Set the desired height
            title: SizedBox(
              height: 100, // Adjust the height as needed
              width: double.infinity, // Set width to occupy the full space
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit
                    .contain, // Use 'contain' for fitting the image within the container
              ),
            ),
          ),
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
