import 'package:flutter/material.dart';

import 'bodyScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(183, 76, 174, 1.0),
        toolbarHeight: 100,
        title: Container(
          height: 100,
          width: double.infinity,
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          // App Information Section
          const Padding(
            padding: EdgeInsets.all(25.0), // Add spacing
            child: Column(
              children: <Widget>[
                Text(
                  'Elevate Your Wellness Journey',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16), // Add spacing
                Text(
                  'Your Dedicated Wellness Companion',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 25),
                Text(
                  'Effortlessly monitor your injuries and discover tailored care suggestions.',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),

              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BodyPage(),
                ),
              );
            },
            child: const Text('Get Advice'),
          ),
        ],
      ),
    );
  }
}
