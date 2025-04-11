import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class BidScreen extends StatefulWidget {
  const BidScreen({super.key});

  @override
  State<BidScreen> createState() => _BidScreenState();
}

class _BidScreenState extends State<BidScreen> with TickerProviderStateMixin {
  int _selectedIndex = 2;
  bool autoBidEnabled = false;
  final TextEditingController _bidController = TextEditingController();
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  double myLastBid = 0.0;
  double highestBid = 0.0;
  String highestBidder = "You";
  String selectedCapsule = 'Public';
  bool isHost = true;

  late Timer _countdownTimer;
  Duration remainingTime = const Duration(hours: 1);

  late Timer _fakeBidTimer;
  final List<String> fakeNames = [
    'Aarav',
    'Meera',
    'Ishaan',
    'Anaya',
    'Vihaan'
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(_glowController);
    _startCountdown();
    _startFakeBidding();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _bidController.dispose();
    _countdownTimer.cancel();
    _fakeBidTimer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          remainingTime -= const Duration(seconds: 1);
        });
      }
    });
  }

  void _startFakeBidding() {
    _fakeBidTimer = Timer.periodic(const Duration(seconds: 7), (timer) async {
      final random = Random();
      double fakeBid = highestBid + 50 + random.nextInt(100);
      String fakeName = fakeNames[random.nextInt(fakeNames.length)];

      await _audioPlayer.play(AssetSource('sound/beep.mp3'));

      setState(() {
        highestBid = fakeBid;
        highestBidder = fakeName;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _submitBid() {
    final bidText = _bidController.text.trim();
    if (bidText.isEmpty || double.tryParse(bidText) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid bid amount."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final bidAmount = double.parse(bidText);
    if (bidAmount > highestBid) {
      setState(() {
        myLastBid = bidAmount;
        highestBid = bidAmount;
        highestBidder = "You";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bid placed: ₹$bidText"),
          backgroundColor: const Color(0xFF2E236C),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bid must be higher than the current highest bid."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    _bidController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final hours = remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = (remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: screenHeight * 0.2,
            decoration: const BoxDecoration(
              color: Color(0xFF2E236C),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Center(
              child: Text(
                "Bidding Details",
                style: TextStyle(
                  fontFamily: "Jaivipurva",
                  fontSize: screenHeight * 0.035,
                  color: Color(0xFFBB8FEF),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.07),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                padding: EdgeInsets.all(screenWidth * 0.06),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Live bidding ends in:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: screenHeight * 0.015),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _TimeBox(label: "hrs", value: hours),
                          _TimeBox(label: "min", value: minutes),
                          _TimeBox(label: "sec", value: seconds),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      const Text("Highest bid:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          "₹${highestBid.toStringAsFixed(2)} by $highestBidder",
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                      SizedBox(height: screenHeight * 0.02),
                      const Text("My last bid:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("₹${myLastBid.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                      const Text("Just now",
                          style: TextStyle(color: Colors.grey)),
                      SizedBox(height: screenHeight * 0.03),
                      const Text("Capsule type:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          _CapsuleTypeChip(
                              label: "Public",
                              selected: selectedCapsule == 'Public',
                              onTap: () {
                                setState(() => selectedCapsule = 'Public');
                              }),
                          _CapsuleTypeChip(
                              label: "Private",
                              selected: selectedCapsule == 'Private',
                              onTap: () {
                                setState(() => selectedCapsule = 'Private');
                              }),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      if (isHost)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Min auto bid: 5.50%",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Switch(
                              value: autoBidEnabled,
                              activeColor: const Color(0xFF2E236C),
                              onChanged: (value) {
                                setState(() => autoBidEnabled = value);
                              },
                            ),
                          ],
                        ),
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFBB8FEF)
                                        .withOpacity(_glowAnimation.value),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: child,
                            );
                          },
                          child: Icon(Icons.local_offer,
                              size: screenHeight * 0.2,
                              color: const Color(0xFF2E236C)),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 10)
                          ],
                        ),
                        child: TextField(
                          controller: _bidController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Enter your bid",
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: screenHeight * 0.025,
                            color: const Color(0xFF2E236C),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Center(
                        child: SizedBox(
                          width: screenWidth * 0.6,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E236C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: _submitBid,
                            child: Text(
                              "Submit Bid",
                              style: TextStyle(
                                fontSize: screenHeight * 0.025,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2E236C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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

class _TimeBox extends StatelessWidget {
  final String label;
  final String value;

  const _TimeBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF2E236C),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value,
              style: const TextStyle(color: Colors.white, fontSize: 20)),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _CapsuleTypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CapsuleTypeChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: const Color(0xFF2E236C),
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
        onSelected: (_) => onTap(),
      ),
    );
  }
}
