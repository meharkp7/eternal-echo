import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:js/js_util.dart';
import 'web3_js_interop.dart';

Future<dynamic> ethRequest(Map<String, dynamic> options) async {
  if (!kIsWeb || ethereum == null) {
    throw UnsupportedError("Web3 not available");
  }

  final args = RequestArguments(method: options['method']);
  return await promiseToFuture(ethereum!.request(args));
}

String? getSelectedAddress() => kIsWeb ? ethereum?.selectedAddress : null;
