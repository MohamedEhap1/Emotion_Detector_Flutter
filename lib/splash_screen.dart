import 'package:emotion_detector/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Emotion Detector',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Image(
            image: AssetImage('assets/images/OIP.jpg'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: LinearProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
