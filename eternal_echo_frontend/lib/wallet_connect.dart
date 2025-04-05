import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:js_util';
import 'package:js/js.dart';

@JS('window.ethereum')
external dynamic get ethereum;

Future<dynamic> ethRequest(Map<String, dynamic> options) async {
  return await promiseToFuture(
      ethereum.callMethod('request', [jsify(options)]));
}

String? getSelectedAddress() {
  return ethereum['selectedAddress'];
}

class WalletConnector {
  late WalletConnect connector;
  SessionStatus? session;
  String? connectedWalletAddress;

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

  Future<void> connectWallet(Function(String) onAddressConnected) async {
    if (ethereum != null) {
      try {
        final chainId = await promiseToFuture(
          ethereum.callMethod('request', [
            jsify({'method': 'eth_chainId'})
          ]),
        );

        if (chainId != '0xaa36a7') {
          await promiseToFuture(
            ethereum.callMethod('request', [
              jsify({
                'method': 'wallet_switchEthereumChain',
                'params': [
                  {'chainId': '0xaa36a7'}
                ]
              })
            ]),
          );
        }

        await ethRequest({'method': 'eth_requestAccounts'});
        final address = getSelectedAddress();
        if (address != null) {
          connectedWalletAddress = address;
          onAddressConnected(address);
        }
      } catch (e) {
        print("Wallet connection error: $e");
      }
    } else {
      print("MetaMask not installed");
    }
  }
}
