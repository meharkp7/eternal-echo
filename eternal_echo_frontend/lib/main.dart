import 'package:flutter/material.dart';
import 'dart:async';
import 'slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SliderScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF100D28),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Text(
                  "Eternal-Echo",
                  style: TextStyle(
                    fontFamily: "Italianno",
                    fontSize: width * 0.15,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = const Color(0xFF7B00D4),
                  ),
                ),
                Positioned(
                  left: 1,
                  top: 1,
                  child: Text(
                    "Eternal-Echo",
                    style: TextStyle(
                      fontFamily: "Italianno",
                      fontSize: width * 0.15,
                      color: const Color(0xFFC084EB),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.05),
            SizedBox(
              width: width * 0.6,
              height: height * 0.3,
              child: Image.asset(
                'assets/capsule.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
