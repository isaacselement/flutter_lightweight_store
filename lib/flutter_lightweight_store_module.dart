import 'package:flutter_lightweight_store/flutter_lightweight_store_platform.dart';

/// A Wrapper that one instance for one module
class FlutterLightweightStoreModule {
  String module;
  String? aesKey;
  String? aesIV;
  bool? isAsyncApply;
  bool? isKeepKeyClearText;

  FlutterLightweightStoreModule(
    /// shared_prefs/[module].xml (Android) or ~/Library/Preferences/[module].plist (iOS)
    this.module, {
    this.aesKey,
    this.aesIV,
    this.isAsyncApply,
    this.isKeepKeyClearText,
  }) {
    FlutterLightweightStorePlatform.register(
      module,
      aesKey: aesKey,
      aesIV: aesIV,
      isAsyncApply: isAsyncApply,
      isKeepKeyClearText: isKeepKeyClearText,
    );
  }

  Future<bool> dispose() async {
    return await FlutterLightweightStorePlatform.unregister(module);
  }

  Future<bool> contains(String key) async {
    return await FlutterLightweightStorePlatform.contains(module, key: key);
  }

  Future<bool> removeKey(String key) async {
    return await FlutterLightweightStorePlatform.removeKey(module, key: key);
  }

  /// Getters
  Future<String?> getString(String key) async {
    return await FlutterLightweightStorePlatform.getString(module, key: key);
  }

  Future<int?> getInt(String key) async {
    return await FlutterLightweightStorePlatform.getInt(module, key: key);
  }

  Future<double?> getDouble(String key) async {
    return await FlutterLightweightStorePlatform.getDouble(module, key: key);
  }

  Future<bool?> getBoolean(String key) async {
    return await FlutterLightweightStorePlatform.getBoolean(module, key: key);
  }

  /// Setters
  Future<bool> setString(String key, String value) async {
    return await FlutterLightweightStorePlatform.setString(module, key: key, value: value);
  }

  Future<bool> setInt(String key, int value) async {
    return await FlutterLightweightStorePlatform.setInt(module, key: key, value: value);
  }

  Future<bool> setDouble(String key, double value) async {
    return await FlutterLightweightStorePlatform.setDouble(module, key: key, value: value);
  }

  Future<bool> setBoolean(String key, bool value) async {
    return await FlutterLightweightStorePlatform.setBoolean(module, key: key, value: value);
  }
}
