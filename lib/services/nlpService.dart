import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

String? token = dotenv.env['OPENAI_API_KEY'];

Future<String> getResult(String userPrompt) async {
  OpenAI openAI = OpenAI.instance.build(
      token: token!,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
      enableLog: true);
  String preprompt =
      "Act as a doctor. I need information about this bodypart: ${userPrompt}";

  final request = CompleteText(
      prompt: preprompt,
      maxTokens: 300,
      model: ModelFromValue(model: kChatGptTurbo0301Model));

  CompleteResponse? response = await openAI.onCompletion(request: request);

  if (response?.choices == null || response!.choices.isEmpty) {
    return "No response";
  }

  return response.choices.first.text;
}
