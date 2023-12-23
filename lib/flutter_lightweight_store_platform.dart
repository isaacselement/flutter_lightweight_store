import 'package:flutter/services.dart';

class FlutterLightweightStorePlatform {
  static MethodChannel methodChannel = const MethodChannel('flutter_lightweight_store');

  static Future<bool> register(
    /// [module] is the file name of Android xml and iOS plist
    String module, {
    String? aesKey,
    String? aesIV,

    /// Android only, options for using apply() to save data to file instead of commit()
    bool? isAsyncApply,

    /// Key is clear text, but value is encrypted, when [aesKey] & [aesIV] is not null
    bool? isKeepKeyClearText,
  }) async {
    Map? result = await methodChannel.invokeMethod<Map>('register', {
      'module': module,
      'aesKey': aesKey ?? '',
      'aesIV': aesIV ?? '',
      'isAsyncApply': isAsyncApply ?? false,
      'isKeepKeyClearText': isKeepKeyClearText ?? false,
    });
    return result?['code'] == 200;
  }

  static Future<bool> unregister(String module) async {
    Map? result = await methodChannel.invokeMethod<Map>('unregister', {'module': module});
    return result?['code'] == 200;
  }

  static Future<bool> contains(String module, {required String key}) async {
    Map? result = await methodChannel.invokeMethod<Map>('contains', {'module': module, 'key': key});
    return result?['data'] == true;
  }

  static Future<bool> removeKey(String module, {required String key}) async {
    Map? result = await methodChannel.invokeMethod<Map>('removeKey', {'module': module, 'key': key});
    return result?['data'] == true;
  }

  /// Getters
  static Future<String?> getString(String module, {required String key}) async {
    Map? result = await methodChannel.invokeMethod<Map>('getString', {'module': module, 'key': key});
    return result?['data'];
  }

  static Future<int?> getInt(String module, {required String key}) async {
    Map? result = await methodChannel.invokeMethod<Map>('getInt', {'module': module, 'key': key});
    dynamic retVal = result?['data'];
    return retVal != null ? int.tryParse(retVal.toString()) : null;
  }

  // static Future<int?> getLong(String module, {required String key}) async {
  // dynamic retVal = result?['data'];
  // return retVal != null ? int.tryParse(retVal.toString()) : null;
  // }

  // static Future<double> getFloat(String module, {required String key}) async {
  // dynamic retVal = result?['data'];
  // return retVal != null ? double.tryParse(retVal.toString()) : null;
  // }

  static Future<double?> getDouble(String module, {required String key}) async {
    Map? result = await methodChannel.invokeMethod<Map>('getDouble', {'module': module, 'key': key});
    dynamic retVal = result?['data'];
    return retVal != null ? double.tryParse(retVal.toString()) : null;
  }

  static Future<bool?> getBoolean(String module, {required String key}) async {
    Map? result = await methodChannel.invokeMethod<Map>('getBoolean', {'module': module, 'key': key});
    dynamic retVal = result?['data'];
    return retVal != null ? retVal == true : null;
  }

  /// Setters
  static Future<bool> setString(String module, {required String key, required String value}) async {
    Map? result = await methodChannel.invokeMethod<Map>('setString', {'module': module, 'key': key, 'value': value});
    return result?['code'] == 200;
  }

  static Future<bool> setInt(String module, {required String key, required int value}) async {
    Map? result = await methodChannel.invokeMethod<Map>('setInt', {'module': module, 'key': key, 'value': value});
    return result?['code'] == 200;
  }

  // static Future<bool> setLong(String module, {required String key, required int value}) async {
  //   Map? result = await methodChannel.invokeMethod<Map>('setLong', {'module': module, 'key': key, 'value': value});
  //   return result?['code'] == 200;
  // }

  // static Future<bool> setFloat(String module, {required String key, required double value}) async {
  //   Map? result = await methodChannel.invokeMethod<Map>('setFloat', {'module': module, 'key': key, 'value': value});
  //   return result?['code'] == 200;
  // }

  static Future<bool> setDouble(String module, {required String key, required double value}) async {
    Map? result = await methodChannel.invokeMethod<Map>('setDouble', {'module': module, 'key': key, 'value': value});
    return result?['code'] == 200;
  }

  static Future<bool> setBoolean(String module, {required String key, required bool value}) async {
    Map? result = await methodChannel.invokeMethod<Map>('setBoolean', {'module': module, 'key': key, 'value': value});
    return result?['code'] == 200;
  }
}
