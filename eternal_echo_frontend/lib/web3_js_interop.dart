@JS()
library web3_js_interop;

import 'package:js/js.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

@JS()
@anonymous
class EthereumProvider {
  external Promise request(RequestArgs args);
  external String? get selectedAddress;
}

@JS()
@anonymous
class RequestArgs {
  external String get method;
  external factory RequestArgs({String method});
}

@JS()
class Promise {
  external Promise then(void Function(dynamic) onFulfilled,
      [Function? onRejected]);
}

@JS('window.ethereum')
external dynamic ethereum;

@JS()
@anonymous
class RequestArguments {
  external String get method;

  external factory RequestArguments({
    String method,
  });
}
