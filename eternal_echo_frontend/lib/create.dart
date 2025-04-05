import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'home.dart';
import 'settings.dart';
import 'web3_wallet_wrapper.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  int _selectedIndex = 2;
  late Web3Client ethClient;
  final TextEditingController _unlockTimeController = TextEditingController();

  final String rpcUrl = "https://sepolia.infura.io/v3/YOUR_INFURA_PROJECT_ID";
  final String contractAddress = "0x7Fb86B4e7fE2cc358a734Cd4F9cD29D3f596a88a";
  late DeployedContract contract;
  late ContractFunction lockFileFunction;

  DateTime? _selectedDate;
  String? selectedFileType;
  String? selectedFilePath;
  String? connectedWalletAddress;

  final List<String> fileTypes = ['Image', 'Document', 'Audio', 'Other'];
  Duration? _timeLeft;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    ethClient = Web3Client(rpcUrl, Client());
    loadContract();
  }

  Future<void> loadContract() async {
    String abi = await DefaultAssetBundle.of(context)
        .loadString("assets/FileVault.json");
    contract = DeployedContract(
      ContractAbi.fromJson(abi, "FileVault"),
      EthereumAddress.fromHex(contractAddress),
    );
    lockFileFunction = contract.function("lockFile");
  }

  Future<void> connectWallet() async {
    if (!kIsWeb) return;

    try {
      await ethRequest({'method': 'eth_requestAccounts'});
      final address = getSelectedAddress();
      if (address != null) {
        setState(() {
          connectedWalletAddress = address;
        });
      }
    } catch (e) {
      print("Wallet connection error: $e");
    }
  }

  Future<void> lockFile() async {
    final file = File(selectedFilePath!);
    final uri = Uri.parse('https://ipfs.infura.io:5001/api/v0/add');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();
    final ipfsHash = jsonDecode(resBody)['Hash'];

    final unlockTime = BigInt.from(int.parse(_unlockTimeController.text));
    final credentials = EthPrivateKey.fromHex("YOUR_PRIVATE_KEY"); // dev only

    await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: lockFileFunction,
        parameters: [ipfsHash, unlockTime],
      ),
      chainId: 11155111,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("File locked with CID: $ipfsHash")),
    );
  }

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        final unixTimestamp =
            (_selectedDate!.millisecondsSinceEpoch / 1000).round();
        _unlockTimeController.text = unixTimestamp.toString();
      });
      _startCountdownTimer();
    }
  }

  void _startCountdownTimer() {
    if (_selectedDate == null) return;

    final unlockTime = DateTime.fromMillisecondsSinceEpoch(
      int.parse(_unlockTimeController.text) * 1000,
    );

    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (unlockTime.isBefore(now)) {
        setState(() => _timeLeft = Duration.zero);
        _countdownTimer?.cancel();
      } else {
        setState(() {
          _timeLeft = unlockTime.difference(now);
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return "${days}d ${hours}h ${minutes}m ${seconds}s";
  }

  void _onItemTapped(int index) {
    if (index == 2) return;
    if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Your Time Capsule",
                style: TextStyle(
                  fontFamily: "JainiPurva",
                  fontSize: 28,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: connectWallet,
                icon: Icon(Icons.account_balance_wallet),
                label: Text("Connect Wallet"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E236C),
                  foregroundColor: Colors.white,
                ),
              ),
              if (connectedWalletAddress != null) ...[
                const SizedBox(height: 10),
                Text(
                  "Connected Wallet:\n$connectedWalletAddress",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select File Type',
                  border: OutlineInputBorder(),
                ),
                value: selectedFileType,
                items: fileTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFileType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles();
                  if (result != null && result.files.single.path != null) {
                    setState(() {
                      selectedFilePath = result.files.single.path!;
                    });
                  }
                },
                icon: Icon(Icons.attach_file),
                label: Text("Upload File"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E236C),
                  foregroundColor: Colors.white,
                ),
              ),
              if (selectedFilePath != null) ...[
                const SizedBox(height: 10),
                Text(
                  "File selected:\n${selectedFilePath!.split('/').last}",
                  style: TextStyle(fontSize: 14),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed:
                    (selectedFilePath != null && connectedWalletAddress != null)
                        ? () => _selectDate(context)
                        : null,
                icon: Icon(Icons.calendar_today),
                label: Text("Pick Unlock Date"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E236C),
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              if (_selectedDate != null)
                Text(
                  "Selected Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}",
                  style: TextStyle(fontSize: 16),
                ),
              if (_timeLeft != null && _timeLeft != Duration.zero)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Time left: ${_formatDuration(_timeLeft!)}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (selectedFilePath != null &&
                        _selectedDate != null &&
                        connectedWalletAddress != null)
                    ? lockFile
                    : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E236C)),
                child: const Text("Lock Time Capsule"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
