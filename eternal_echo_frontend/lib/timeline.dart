import 'package:flutter/material.dart';
import 'home.dart';
import 'settings.dart';
import 'create.dart';

class TimelineScreen extends StatefulWidget {
  final Map<String, String>? newCapsule;

  const TimelineScreen({super.key, this.newCapsule});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  int _selectedIndex = 1;

  List<Map<String, String>> capsules = [
    {
      "date": "16 April 2025, 7:30PM",
      "topic": "Mehar’s 18th Birthday",
      "subtitle": "Ready to be Unlocked"
    },
    {
      "date": "3 January 2026, 2:30AM",
      "topic": "To Kritika, enjoy your day",
      "subtitle": ""
    },
    {
      "date": "13 April 2029, 7:00PM",
      "topic": "4 years to the trip to Trampoline Park",
      "subtitle": "(Enjoy the pictures)"
    },
    {
      "date": "23 July 2029, 9:00PM",
      "topic": "To my future self…",
      "subtitle": ""
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.newCapsule != null) {
      capsules.insert(0, widget.newCapsule!);
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) return;
    if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CreateScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _showOverlay() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AnimatedOverlay();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEAE0FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E236C),
        elevation: 0,
        title: const Text(
          "Eternal-Echo",
          style: TextStyle(
            fontFamily: "Italianno",
            fontSize: 34,
            color: Color(0xFFBB8FEF),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              itemCount: capsules.length,
              itemBuilder: (context, index) {
                final item = capsules[index];
                return _buildTimelineCard(
                  item['date']!,
                  item['topic']!,
                  item['subtitle'] ?? '',
                  screenWidth,
                  onTap: _showOverlay,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E236C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.3,
                ),
              ),
              onPressed: () {},
              child: const Text(
                "View More",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          _buildBottomNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(
      String date, String topic, String? subtitle, double screenWidth,
      {VoidCallback? onTap}) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Image.asset("assets/capsule.png", height: 40),
              Container(width: 2, height: 80, color: Colors.black),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Next Capsule: $date",
                    style: const TextStyle(
                      fontFamily: "Italianno",
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Topic: $topic",
                    style: const TextStyle(
                      fontFamily: "Italianno",
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Center(
                        child: GestureDetector(
                          onTap: onTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            width: double.infinity,
                            color: const Color(0xFF2E236C),
                            child: Center(
                              child: Text(
                                subtitle,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2E236C),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color(0xFFBB8FEF),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.group), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          ],
        ),
      ),
    );
  }
}

class AnimatedOverlay extends StatefulWidget {
  @override
  _AnimatedOverlayState createState() => _AnimatedOverlayState();
}

class _AnimatedOverlayState extends State<AnimatedOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
        .animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: Image.asset("assets/capsule_glow.png", width: 300),
        ),
      ),
    );
  }
}
