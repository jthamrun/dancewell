import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dancewell/history_info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> assessmentMap = {};
  List<String> dateList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAssessment();
  }

  Future<void> loadAssessment() async {
    String key = 'assessment';
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(key)) {
      setState(() {
        assessmentMap = jsonDecode(prefs.getString(key)!);
        dateList = assessmentMap.keys.toList();
        dateList.sort((a, b) => b.compareTo(a));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('DanceWell', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: assessmentMap.isNotEmpty
            ? ListView.builder(
                padding: const EdgeInsets.all(8),
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: dateList.length,
                itemBuilder: (BuildContext context, int index) {
                  String date = dateList[index];
                  String organ = assessmentMap[date]['organ'];
                  return Card(
                      color: const Color.fromRGBO(236, 214, 233, 1.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HistoryInfoPage(
                                        date: date,
                                        result: assessmentMap[date]['result'],
                                        organ: assessmentMap[date]['organ'],
                                      )));
                        },
                        title: Text(
                          date,
                          style: const TextStyle(fontSize: 20),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_sharp),
                      ));
                })
            : Center(child: Text('No History')));
  }
}
