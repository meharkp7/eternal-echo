import 'package:flutter/material.dart';
import 'login2.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/background_light.png",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.08),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      "Eternal-Echo",
                      style: TextStyle(
                        fontFamily: "Italianno",
                        fontSize: screenHeight * 0.09,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 1.5
                          ..color = const Color(0xFFC7B1F5),
                      ),
                    ),
                    Text(
                      "Eternal-Echo",
                      style: TextStyle(
                        fontFamily: "Italianno",
                        fontSize: screenHeight * 0.09,
                        color: const Color(0xFF2E236C),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                Image.asset(
                  "assets/capsule.png",
                  height: screenHeight * 0.18,
                ),
                SizedBox(height: screenHeight * 0.06),
                SizedBox(
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.065,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E236C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login2Screen()),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontFamily: "JainiPurva",
                        fontSize: screenHeight * 0.035,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.065,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E236C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login2Screen()),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontFamily: "JainiPurva",
                        fontSize: screenHeight * 0.035,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),
                Text(
                  "Continue With",
                  style: TextStyle(
                    fontSize: screenHeight * 0.022,
                    fontFamily: "JainiPurva",
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Image.asset(
                  "assets/icons.png",
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.06,
                  fit: BoxFit.fitWidth,              
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}