import 'package:flutter/material.dart';


import 'bodyScreen.dart';


class PreAssessment extends StatefulWidget {
  const PreAssessment({Key? key}) : super(key: key);


  @override
  State<PreAssessment> createState() => _PreAssessmentState();
}
class _PreAssessmentState extends State<PreAssessment> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DanceWell', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Column (


          children:[
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.6), // Adjust opacity as needed
                BlendMode.srcATop,
              ),
              //height: imageHeight, // Set the height of the image container
              child: Image.asset('assets/images/preassessment.png', fit: BoxFit.contain),
            ),
            SizedBox(height: 64), // Adjust based on your image position
            Text(
              'Welcome to your personal assessment',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color for visibility
              ),
            ),
            SizedBox(height: 26),
            Text(
              'Quickly answer a few questions about your injury to get a possible diagnosis and treatment options',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.black, // Text color for visibility
              ),
            ),
            SizedBox(height: 32), // Spacing for button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BodyPage()),
                );// Define the action when the button is pressed
              },
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.grey[100], // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
