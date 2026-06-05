import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// True on Android and iOS where mobile-only plugins are supported.
bool get isMobilePlatform {
  if (kIsWeb) return false;
  return Platform.isAndroid || Platform.isIOS;
}
