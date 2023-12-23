import 'package:flutter_lightweight_store/flutter_lightweight_store_module.dart';

class FlutterStoreInstance {
  static final String _aesKey = "AbCAbCAb" * 4;

  static final String _aesIV = "AbCAbCAb" * 2;

  /// fully encrypted
  /// saved file are: ~/shared_prefs/com.secure.fully.xml(Android) or ~/Library/Preferences/com.secure.fully.plist(iOS)
  static FlutterLightweightStoreModule secure =
      FlutterLightweightStoreModule("com.secure.fully", aesKey: _aesKey, aesIV: _aesIV);

  /// partially encrypted: key is clear text, value is encrypted
  static FlutterLightweightStoreModule semiSafe =
      FlutterLightweightStoreModule("com.secure.semi", aesKey: _aesKey, aesIV: _aesIV, isKeepKeyClearText: true);

  /// all keys and values are clear text
  static FlutterLightweightStoreModule common = FlutterLightweightStoreModule("com.common.use");

  /// config data, if you need
  static FlutterLightweightStoreModule config = FlutterLightweightStoreModule("com.app.config", isAsyncApply: true);

  /// user information data, if you need
  static FlutterLightweightStoreModule user =
      FlutterLightweightStoreModule("com.app.user.info", aesKey: _aesKey, aesIV: _aesIV, isAsyncApply: true);
}
