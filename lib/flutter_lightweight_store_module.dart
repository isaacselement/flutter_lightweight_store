import 'package:flutter_lightweight_store/flutter_lightweight_store_platform.dart';

/// A Wrapper that one instance for one module
class FlutterLightweightStoreModule {
  /// shared_prefs/[module].xml (Android) or ~/Library/Preferences/[module].plist (iOS)
  String module;

  /// AES KEY for encrypting key-value
  String? aesKey;

  /// AES IV for encrypting key-value
  String? aesIV;

  /// Android only, options for using apply() to save data to file instead of commit()
  bool? isAsyncApply;

  /// For key-value data, key is clear text, but value is encrypted, when [aesKey] & [aesIV] is not null
  bool? isKeepKeyClearText;

  FlutterLightweightStoreModule(
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

  /// Check if the key exists
  Future<bool> contains(String key) async {
    return await FlutterLightweightStorePlatform.contains(module, key: key);
  }

  /// Remove the key-value pair
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
