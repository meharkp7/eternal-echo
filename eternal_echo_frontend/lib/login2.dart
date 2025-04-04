import 'package:flutter/material.dart';

class Login2Screen extends StatelessWidget {
  const Login2Screen({super.key});

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
                decoration: BoxDecoration(
                  color: const Color(0xFF2E236C), 
                  borderRadius: const BorderRadius.vertical(
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField("Name"),
                    SizedBox(height: screenHeight * 0.03),
                    _buildTextField("Email Id"),
                    SizedBox(height: screenHeight * 0.03),
                    _buildTextField("Phone No."),
                    SizedBox(height: screenHeight * 0.05),
                    Center(
                      child: SizedBox(
                        width: screenWidth * 0.35,
                        height: screenHeight * 0.06,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E236C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontFamily: "JainiPurva",
                              fontSize: screenHeight * 0.025,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "JainiPurva",
            fontSize: 18,
            color: Color(0xFF2E236C),
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2E236C), 
            borderRadius: BorderRadius.circular(15),
          ),
          child: const TextField(
            style: TextStyle(
              color: Colors.white,
              fontFamily: "JainiPurva",
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}