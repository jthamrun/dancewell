import 'dart:convert';
import 'dart:math';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import "package:dancewell/models/videos.dart";

class HistoryInfoPage extends StatefulWidget {
  const HistoryInfoPage(
      {Key? key, required this.result, required this.date, required this.organ})
      : super(key: key);
  final String result;
  final String organ;
  final String date;

  @override
  State<HistoryInfoPage> createState() => _HistoryInfoPageState();
}

class _HistoryInfoPageState extends State<HistoryInfoPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: Text('DanceWell', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              MarkdownBody(
                data: '### Date: ${widget.date}',
              ),
              SizedBox(
                height: 12,
              ),
              MarkdownBody(data: widget.result),
            ],
          ),
        ));
  }
}
