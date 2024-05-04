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
    'Shoulder': {'height': 0.13, 'width': 0.16},
    'Cervical spine': {'height': 0.115, 'width': 0.68},
    'Elbow': {'height': 0.15, 'width': 0.85},
    'Thoracic spine': {'height': 0.248, 'width': 0.62},
    'Lumbar spine': {'height': 0.32, 'width': 0.66},
    'SI joint': {'height': 0.37, 'width': 0.7},
    'Hip': {'height': 0.36, 'width': 0.15},
    'Thigh': {'height': 0.5, 'width': 0.2},
    'Knee': {'height': 0.525, 'width': 0.75},
    'Lower leg': {'height': 0.65, 'width': 0.18},
    'Ankle': {'height': 0.74, 'width': 0.23},
    'Foot': {'height': 0.715, 'width': 0.82},
    'Other': {'height': 0.715, 'width': 0.55}
  };


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  Widget placeBodyPart(double top, double left, String bodyPart) {
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
          )
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('DanceWell', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      height: height * 0.8,
                      child: Image.asset(
                        'assets/human_body.jpg',
                        fit: BoxFit.fitHeight,
                      ),
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