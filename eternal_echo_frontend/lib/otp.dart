import 'package:flutter/material.dart';
import 'home.dart'; // Import home screen

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onOtpEntered(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus(); // Move to next field
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus(); // Move to previous field if backspaced
    }
  }

  void _onSubmit() {
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color(0xFFBB8FEF)),
          ),
          Column(
            children: [
              Container(
                height: screenHeight * 0.3,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E236C),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Eternal-Echo",
                      style: TextStyle(
                        fontFamily: "Italianno",
                        fontSize: screenHeight * 0.07,
                        color: const Color(0xFFBB8FEF),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Image.asset(
                      "assets/capsule.png",
                      height: screenHeight * 0.1,
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              const Text(
                "Verify the OTP",
                style: TextStyle(
                  fontFamily: "JainiPurva",
                  fontSize: 22,
                  color: Color(0xFF2E236C),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    width: screenWidth * 0.15,
                    height: screenWidth * 0.15,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E236C),
                      borderRadius: BorderRadius.circular(screenWidth * 0.07),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLength: 1,
                      decoration: const InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => _onOtpEntered(index, value),
                    ),
                  );
                }),
              ),

              SizedBox(height: screenHeight * 0.05),

              SizedBox(
                width: screenWidth * 0.35,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E236C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _onSubmit, // 🔹 Navigate on submit
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontFamily: "JainiPurva",
                      fontSize: screenHeight * 0.025,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E236C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {}, // 🔹 Implement Resend OTP later
                  child: Text(
                    "Resend Code",
                    style: TextStyle(
                      fontFamily: "JainiPurva",
                      fontSize: screenHeight * 0.025,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}