import 'dart:convert';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'assessmentScreen.dart';

class MoreSymptomPage extends StatefulWidget {
  const MoreSymptomPage({
    Key? key,
    this.organ,
  }) : super(key: key);
  final organ;

  @override
  State<MoreSymptomPage> createState() => _MoreSymptomPageState();
}

class _MoreSymptomPageState extends State<MoreSymptomPage> {
  late final model = GenerativeModel(
      apiKey: dotenv.env['OPENAI_API_KEY']!, model: 'gemini-pro');
  List questions = [];
  List<String> responses = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // gptFunctionCalling();
    geminiFunctionCalling();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  ///parameter name is require
  ////
  /*
  void gptFunctionCalling() async {
    String systemPrompt =
        'act as a doctor. Provide an assessment of my symptoms and give me some advices';
    String userPrompt =
        'Please provide 10 yes/no questions related to ${widget.organ} as a json format'
        ' to assess my health. Please only return the json file. DO NOT type '
        'anything at the beginning or end of the json. The json should look like '
        'this {"questions":["question": <question>]}';
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
      model: GptTurbo16k0631Model(),
    );

    ChatCTResponse? response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      String? stringList = element.message?.content;
      // print(stringList);
      setState(() {
        Map<String, dynamic> result = jsonDecode(stringList!);
        questions = result['questions'];
        print(questions);
        responses = List.generate(questions.length, (index) => "No");
      });
    }
  }
  */

  void geminiFunctionCalling() async {
    String systemPrompt =
        'act as a doctor. Provide an assessment of my symptoms and give me some advices';
    String userPrompt =
        'Please provide 10 yes/no questions related to ${widget.organ} as a json format'
        ' to assess my health. Please only return the json file. DO NOT type '
        'anything at the beginning or end of the json. The json should look like '
        'this {"questions":["question": <question>]}';

    final chat = model.startChat(history: [
      Content.text(userPrompt),
      Content.model([TextPart(systemPrompt)]),
    ]);

    final message = userPrompt;

    final response = await chat.sendMessage(Content.text(message));

    if (!mounted) return;

    setState(() {
      Map<String, dynamic> result = jsonDecode(response.text!);
      questions = result['questions'];
      responses = List.generate(questions.length, (index) => "No");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: const Color.fromRGBO(183, 76, 174, 1.0),
          toolbarHeight: 100,
          // Set the desired height
          title: Container(
            height: 100, // Adjust the height as needed
            width: double.infinity, // Set width to occupy the full space
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit
                  .contain, // Use 'contain' for fitting the image within the container
            ),
          ),
        ),
        body: questions.isNotEmpty
            ? ListView(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: questions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child:
                                          Text(questions[index]['question'])),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Radio<String>(
                                          value: "Yes",
                                          groupValue: responses[index],
                                          onChanged: (value) {
                                            setState(() {
                                              responses[index] = value!;
                                            });
                                          },
                                        ),
                                        const Text("Yes"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Radio<String>(
                                          value: "No",
                                          groupValue: responses[index],
                                          onChanged: (value) {
                                            setState(() {
                                              responses[index] = value!;
                                            });
                                          },
                                        ),
                                        const Text("No"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      List allResponse = [];
                      for (int i = 0; i < questions.length; i++) {
                        allResponse.add('${questions[i]} ${responses[i]}');
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssessmentPage(
                              responses: allResponse, organ: widget.organ),
                        ),
                      );
                    },
                    child: const Text("Submit"),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                ),
              ));
  }
}
