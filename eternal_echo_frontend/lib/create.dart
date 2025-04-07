import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'home.dart';
import 'settings.dart';
import 'web3_wallet_wrapper.dart';
import 'timeline.dart';

const String PINATA_API_KEY = 'dda9599d59af1305eacc';
const String PINATA_SECRET_API_KEY =
    '5c2b53790dc7ec30e916dda56ff39700002392b25795ce9225f60581b5498ac7';
const String CONTRACT_ADDRESS = '0xCb8011498BB28B5F9bAE531cC4F15bb9de40b8b0';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  int _selectedIndex = 2;
  late Web3Client ethClient;
  final TextEditingController _unlockTimeController = TextEditingController();
  final TextEditingController _capsuleNameController = TextEditingController();

  static const String rpcUrl = "http://127.0.0.1:8545/";
  final String contractAddress = CONTRACT_ADDRESS;
  late DeployedContract contract;
  late ContractFunction lockFileFunction;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? selectedFileType;
  String? selectedFilePath;
  String? connectedWalletAddress;

  Uint8List? fileBytes;
  String? fileName;

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

  void _startCountdownTimer() {
    if (_selectedDate == null || _selectedTime == null) return;

    final unlockDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (unlockDateTime.isBefore(now)) {
        setState(() => _timeLeft = Duration.zero);
        _countdownTimer?.cancel();
      } else {
        setState(() {
          _timeLeft = unlockDateTime.difference(now);
        });
      }
    });
  }

  Future<void> lockFile() async {
    print("lockFile function called!");
    if (_unlockTimeController.text.isEmpty ||
        int.tryParse(_unlockTimeController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a valid unlock time.")),
      );
      return;
    }

    final uri = Uri.parse('https://api.pinata.cloud/pinning/pinFileToIPFS');
    final request = http.MultipartRequest('POST', uri);

    const String pinataApiKey = "dda9599d59af1305eacc";
    const String pinataSecretApiKey =
        "5c2b53790dc7ec30e916dda56ff39700002392b25795ce9225f60581b5498ac7";
    request.headers['pinata_api_key'] = pinataApiKey;
    request.headers['pinata_secret_api_key'] = pinataSecretApiKey;

    if (kIsWeb) {
      request.files.add(http.MultipartFile.fromBytes('file', fileBytes!,
          filename: fileName!));
    } else {
      request.files
          .add(await http.MultipartFile.fromPath('file', selectedFilePath!));
    }

    try {
      final response = await request.send();
      final resBody = await response.stream.bytesToString();
      print("Pinata Response: $resBody");
      final Map<String, dynamic> jsonResponse = jsonDecode(resBody);
      final String? ipfsHash = jsonResponse['IpfsHash'];
      print("IPFS Hash: $ipfsHash");

      if (ipfsHash == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to get IPFS hash from Pinata response.")),
        );
        return;
      }

      final parsedUnlockTime = int.parse(_unlockTimeController.text);

      final unlockDateTime =
          DateTime.fromMillisecondsSinceEpoch(parsedUnlockTime * 1000);

      final credentials = EthPrivateKey.fromHex(
          "38a880d6bb43a44b4a980404ac1a0fa5ffb8ce5dfb6b3d44d037e5a6f8a81df2");

      print("Sending transaction...");
      await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: lockFileFunction,
          parameters: [
            ipfsHash,
            BigInt.from(parsedUnlockTime),
          ],
        ),
        chainId: 31337,
      );
      print("Transaction sent successfully!");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File locked with CID: $ipfsHash")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TimelineScreen(
            newCapsule: {
              "date":
                  "${unlockDateTime.day} ${unlockDateTime.month} ${unlockDateTime.year}, ${unlockDateTime.hour}:${unlockDateTime.minute}${unlockDateTime.hour < 12 ? 'AM' : 'PM'}",
              "topic": _capsuleNameController.text,
              "subtitle": "Ready to be Unlocked",
            },
          ),
        ),
      );
    } catch (e) {
      print("Error in lockFile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred while locking the file: $e")),
      );
    }
  }

  void _selectDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;

          final unlockDateTime = DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            _selectedTime!.hour,
            _selectedTime!.minute,
          );

          final unixTimestamp =
              (unlockDateTime.millisecondsSinceEpoch / 1000).round();
          _unlockTimeController.text = unixTimestamp.toString();
          _startCountdownTimer();
        });
      }
    }
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
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("--- Build Method ---");
    print("kIsWeb: $kIsWeb");
    print("fileBytes != null: ${fileBytes != null}");
    print("selectedFilePath: $selectedFilePath");
    print("_selectedDate: $_selectedDate");
    print("_selectedTime: $_selectedTime");
    print("connectedWalletAddress: $connectedWalletAddress");
    print("_unlockTimeController.text: ${_unlockTimeController.text}");

    bool isFileSelected =
        (kIsWeb && fileBytes != null) || (!kIsWeb && selectedFilePath != null);
    bool isDateTimeSelected = _selectedDate != null && _selectedTime != null;
    bool isWalletConnected = connectedWalletAddress != null;

    bool isLockEnabled =
        isFileSelected && isDateTimeSelected && isWalletConnected;

    print("isFileSelected: $isFileSelected");
    print("isDateTimeSelected: $isDateTimeSelected");
    print("isWalletConnected: $isWalletConnected");
    print("isLockEnabled: $isLockEnabled");
    print("----------------------");

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
              Text("Create Your Time Capsule",
                  style: TextStyle(
                      fontFamily: "JainiPurva",
                      fontSize: 28,
                      color: Colors.black87)),
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
                Text("Connected Wallet:\n$connectedWalletAddress",
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
              ],
              const SizedBox(height: 20),
              TextFormField(
                controller: _capsuleNameController,
                decoration: InputDecoration(
                  labelText: 'Capsule Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    labelText: 'Select File Type',
                    border: OutlineInputBorder()),
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
                  final result =
                      await FilePicker.platform.pickFiles(withData: kIsWeb);
                  if (result != null) {
                    if (kIsWeb) {
                      fileBytes = result.files.single.bytes;
                      fileName = result.files.single.name;
                    } else {
                      selectedFilePath = result.files.single.path!;
                    }
                    setState(() {});
                  }
                },
                icon: Icon(Icons.attach_file),
                label: Text("Upload File"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E236C),
                  foregroundColor: Colors.white,
                ),
              ),
              if (kIsWeb && fileName != null)
                Text("File selected: $fileName",
                    style: TextStyle(fontSize: 14)),
              if (!kIsWeb && selectedFilePath != null)
                Text("File selected: ${selectedFilePath!.split('/').last}",
                    style: TextStyle(fontSize: 14)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: ((kIsWeb && fileBytes != null ||
                            !kIsWeb && selectedFilePath != null) &&
                        connectedWalletAddress != null)
                    ? () => _selectDateTime(context)
                    : null,
                icon: Icon(Icons.calendar_today),
                label: Text("Pick Unlock Date & Time"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E236C),
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              if (_selectedDate != null && _selectedTime != null)
                Text(
                  "Selected: ${_selectedDate!.toLocal().toString().split(' ')[0]} @ ${_selectedTime!.format(context)}",
                  style: TextStyle(fontSize: 14),
                ),
              if (_timeLeft != null && _timeLeft != Duration.zero)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("Time left: ${_formatDuration(_timeLeft!)}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple)),
                ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: isLockEnabled
                    ? () {
                        print("GestureDetector tapped, isLockEnabled is true");
                        lockFile();
                      }
                    : () {
                        print("GestureDetector tapped, isLockEnabled is false");
                      },
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E236C),
                  ),
                  onPressed: null, // Set onPressed to null here
                  child: const Text("Lock Time Capsule"),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Color(0xFF2E236C),
      selectedItemColor: Color(0xFFBB8FEF),
      unselectedItemColor: Colors.white60,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Timeline'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Create'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
