import 'package:flutter/material.dart';
import 'pre_assessment.dart';
import 'aboutus.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Calculate the height for the image, assuming AppBar and Bottom Navigation Bar
    // take a certain amount of space. Adjust the multiplier as needed.
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = kToolbarHeight;
    double bottomBarHeight = kBottomNavigationBarHeight;
    double imageHeight = (screenHeight - appBarHeight - bottomBarHeight) * 0.4;


    return Scaffold(
      appBar: AppBar(
        title: Text('DanceWell', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            //height: imageHeight, // Set the height of the image container
            child: Image.asset('assets/images/homescreenimage.png', fit: BoxFit.contain),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome to DanceWell',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Your Dance Injury Solution',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PreAssessment()),
                      );
                      // Define the action when the button is pressed
                    },
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),


                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AboutUs()),
                      );
                      // Define the action when the button is pressed
                    },
                    child: Text(
                      'About Us',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      // Consider adding a BottomNavigationBar here
    );
  }
}
