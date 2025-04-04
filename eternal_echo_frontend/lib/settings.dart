import 'package:flutter/material.dart';
import 'home.dart';
import 'timeline.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TimelineScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAE0FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E236C),
        elevation: 0,
        title: const Text(
          "Eternal-Echo",
          style: TextStyle(
            fontFamily: "JainiPurva",
            fontSize: 34,
            color: Color(0xFFBB8FEF),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2E236C),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Text("CG", style: TextStyle(fontSize: 28, color: Colors.white)),
                ),
                SizedBox(height: 10),
                Text(
                  "Christine T. Greenhalgh",
                  style: TextStyle(
                    fontFamily: "JainiPurva",
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
            ),
            child: Column(
              children: [
                const ListTile(title: Text("Mobile Number: **********")),
                const Divider(),
                const ListTile(title: Text("Email: **********@gmail.com")),
                const Divider(),
                const ListTile(title: Text("Privacy"), trailing: Icon(Icons.arrow_forward_ios)),
                const Divider(),
                const ListTile(title: Text("Terms and Conditions"), trailing: Icon(Icons.arrow_forward_ios)),
                const Divider(),
                SwitchListTile(
                  title: const Text("Private Account"),
                  value: true,
                  onChanged: (val) {},
                ),
                const Divider(),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Log Out", style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
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
          selectedItemColor: const Color.fromARGB(255, 47, 2, 97),
          unselectedItemColor: const Color(0xFFBB8FEF),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.group), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          ],
        ),
      ),
    );
  }
}