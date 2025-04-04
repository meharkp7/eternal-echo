import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  _SliderScreenState createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> sliderData = [
    {
      "icon": "assets/envelope.png",
      "text": "Write heartfelt messages for loved ones (or your future self)",
    },
    {
      "icon": "assets/lock.png",
      "text": "Your secrets stay yours.",
    },
    {
      "icon": "assets/treasure.png",
      "text": "Preserve your emotions, surprises, and wisdom for the future—forever.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      if (_currentIndex < sliderData.length - 1) {
        _pageController.animateToPage(
          _currentIndex + 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _startAutoSlide();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/background.png",
              fit: BoxFit.cover,
            ),
          ),
          PageView.builder(
            controller: _pageController,
            itemCount: sliderData.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "Eternal-Echo",
                        style: TextStyle(
                          fontFamily: "Italianno",
                          fontSize: screenHeight * 0.08,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1.5
                            ..color = const Color(0xFF7B00D4),
                        ),
                      ),
                      Text(
                        "Eternal-Echo",
                        style: TextStyle(
                          fontFamily: "Italianno",
                          fontSize: screenHeight * 0.08,
                          color: const Color(0xFFC084EB),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Image.asset(
                    "assets/capsule.png",
                    height: screenHeight * 0.18,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Image.asset(
                    sliderData[index]["icon"]!,
                    height: screenHeight * 0.16,
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: Text(
                      sliderData[index]["text"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenHeight * 0.024,
                        color: const Color(0xFFACD9DA),
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      sliderData.length,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == i ? Colors.purple : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
