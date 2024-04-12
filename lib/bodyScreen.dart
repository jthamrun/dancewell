import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dancewell/models/history.dart';
import 'package:dancewell/moreSymptomScreen.dart';
import 'package:dancewell/services/sharedPrefService.dart';

class BodyPage extends ConsumerStatefulWidget {
  const BodyPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends ConsumerState<BodyPage> {
  Map bodyParts = {
    'Shoulder': {'height': 0.1, 'width': 0.15},
    'Cervical spine': {'height': 0.08, 'width': 0.65},
    'Elbow': {'height': 0.12, 'width': 0.75},
    'Thoracic spine': {'height': 0.23, 'width': 0.58},
    'Lumbar spine': {'height': 0.28, 'width': 0.65},
    'SI joint': {'height': 0.35, 'width': 0.7},
    'Hip': {'height': 0.3, 'width': 0.15},
    'Thigh': {'height': 0.43, 'width': 0.2},
    'Knee': {'height': 0.45, 'width': 0.7},
    'Lower leg': {'height': 0.55, 'width': 0.2},
    'Ankle': {'height': 0.65, 'width': 0.2},
    'Foot/Toes': {'height': 0.63, 'width': 0.75}
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Positioned placeBodyPart(double top, double left, String bodyPart) {
    return Positioned(
        top: top, // Adjust the position as needed
        left: left,
        child: GestureDetector(
          child: Column(
            children: [
              Card(
                  child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(bodyPart),
              ))
            ],
          ),
          onTap: () {
            goToMoreSymptomPage(bodyPart);
          },
        ));
  }

  Future<void> goToMoreSymptomPage(String organ) async {
    BodyHistory bodyHistory = BodyHistory(name: organ, date: DateTime.now());
    List<String>? bodyHistoryList =
        await SharedPrefService.getStringList('bodyHistory');
    if (bodyHistoryList == null) {
      bodyHistoryList = [];
    }

    bodyHistoryList.add(bodyHistory.toJson());
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MoreSymptomPage(
                organ: organ,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(183, 76, 174, 1.0),
        toolbarHeight: 100,
        title: SizedBox(
          height: 100,
          width: double.infinity,
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: height * 0.7,
                    child: Image.asset(
                      'assets/human_body.jpg',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  // Overlay body parts text
                  for (var entry in bodyParts.entries)
                    placeBodyPart(
                      height * entry.value['height'],
                      width * entry.value['width'],
                      entry.key,
                    ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              textAlign: TextAlign.center,
              'Click the area on the body that is experiencing pain',
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
