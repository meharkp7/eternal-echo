@JS()
library metamask_interop;

import 'package:js/js.dart';

@JS('connectMetamask')
external Future<String?> connectMetamask();
