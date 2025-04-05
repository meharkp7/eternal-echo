import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WalletConnector {
  late WalletConnect connector;
  SessionStatus? session;

  WalletConnector() {
    connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'Eternal Echo',
        description: 'Time capsule with MetaMask + Encryption',
        url: 'https://eternalecho.app',
        icons: ['https://walletconnect.org/walletconnect-logo.png'],
      ),
    );
  }

  Future<String?> connectWallet() async {
    if (!connector.connected) {
      session = await connector.createSession(
        onDisplayUri: (uri) async {
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        },
      );
    }
    return session?.accounts.first;
  }
}
