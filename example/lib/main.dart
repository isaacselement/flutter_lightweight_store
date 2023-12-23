import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:example/flutter_store_instances.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lightweight_store/flutter_lightweight_store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    doStoreTest();

    /// print out the app sandbox directory
    getApplicationDocumentsDirectory().then((value) {
      print('@@@@@@ getApplicationDocumentsDirectory: ${value.absolute.path}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: const Center(child: Text('Running on: \n')),
      ),
    );
  }

  void doStoreTest() async {
    {
      FlutterLightweightStoreModule secure = FlutterStoreInstance.secure;
      await secure.setString("String", json.encode({"json": "你🚫好GoodJob"}));
      var str = await secure.getString("String");
      Map map = str != null ? json.decode(str) : null;
      print('@@@@@@ [secure] map: $map');
    }

    {
      FlutterLightweightStoreModule semiSafe = FlutterStoreInstance.semiSafe;
      await semiSafe.setString("String", json.encode({"json": "你🚫好GoodJob"}));
      var str = await semiSafe.getString("String");
      Map map = str != null ? json.decode(str) : null;
      print('@@@@@@ [semiSafe] map: $map');
    }

    {
      FlutterLightweightStoreModule user = FlutterStoreInstance.user;
      await user.setString("String", json.encode({"json": "你🚫好GoodJob"}));
      var str = await user.getString("String");
      Map map = str != null ? json.decode(str) : null;
      print('@@@@@@ [user] map: $map');
    }

    {
      FlutterLightweightStoreModule config = FlutterStoreInstance.config;
      await config.setString("String", json.encode({"json": "你🚫好GoodJob"}));
      var str = await config.getString("String");
      Map map = str != null ? json.decode(str) : null;
      print('@@@@@@ [config] map: $map');
    }

    {
      /// mark this instance as static, so you can access this instance across the app
      FlutterLightweightStoreModule sp = FlutterLightweightStoreModule("com.your.package.name");
      await sp.setString("StringKey", "Hello world");
      await sp.setInt("IntKey", 10086);
      await sp.setDouble("DoubleKey", 10086.12306);
      await sp.setBoolean("BooleanKey", true);

      var str = await sp.getString("StringKey");
      var int = await sp.getInt("IntKey");
      var double = await sp.getDouble("DoubleKey");
      var boolean = await sp.getBoolean("BooleanKey");
      print('@@@@@@ [SP] setter & getter: string -> $str, int -> $int, double -> $double, boolean -> $boolean');

      await sp.removeKey('StringKey');
      bool isContains = await sp.contains('StringKey');

      FlutterLightweightStoreModule common = FlutterStoreInstance.common;

      /// contains
      String keyContains = '__ok_contains__';
      await common.setBoolean(keyContains, true);
      bool containsVal1 = await common.contains(keyContains);
      await common.removeKey(keyContains);
      bool containsVal2 = await common.contains(keyContains);
      var containsVal3 = await common.getBoolean(keyContains);

      /// string
      String keyString = '__ok_string__';
      await common.setString(keyString, "Hello 💯🐶你好");
      var stringValue1 = await common.getString(keyString);
      await common.setString(keyString, "💯💯💯💯💯💯");
      var stringValue2 = await common.getString(keyString);
      await common.removeKey(keyString);
      var stringValue3 = await common.getString(keyString);

      /// int
      String keyInteger = '__ok_int__';
      await common.setInt(keyInteger, 100096666666);
      var intValue1 = await common.getInt(keyInteger);
      await common.setInt(keyInteger, 777777777777);
      var intValue2 = await common.getInt(keyInteger);
      await common.removeKey(keyInteger);
      var intValue3 = await common.getInt(keyInteger);

      /// double
      String keyDouble = '__ok_double__';
      await common.setDouble(keyDouble, 1009.888);
      var doubleValue1 = await common.getDouble(keyDouble);
      await common.setDouble(keyDouble, 888888.000999);
      var doubleValue2 = await common.getDouble(keyDouble);
      await common.removeKey(keyDouble);
      var doubleValue3 = await common.getDouble(keyDouble);

      /// bool
      String keyBoolean = '__ok_boolean__';
      await common.setBoolean(keyBoolean, true);
      var booleanValue1 = await common.getBoolean(keyBoolean);
      await common.setBoolean(keyBoolean, false);
      var booleanValue2 = await common.getBoolean(keyBoolean);
      await common.removeKey(keyBoolean);
      var booleanValue3 = await common.getBoolean(keyBoolean);

      print(''
          '@@@@@@ [common]'
          '\n'
          'contains: $containsVal1, $containsVal2. If is null after removed? $containsVal3 (${containsVal3 == null}),'
          '\n'
          'string: $stringValue1, $stringValue2. If is null after removed? $stringValue3 (${stringValue3 == null})'
          '\n'
          'int: $intValue1, $intValue2. If is null after removed? $intValue3 (${intValue3 == null})'
          '\n'
          'double: $doubleValue1, $doubleValue2. If is null after removed? $doubleValue3 (${doubleValue3 == null})'
          '\n'
          'boolean: $booleanValue1, $booleanValue2. If is null after removed? $booleanValue3 (${booleanValue3 == null})'
          '\n'
          '');

      await common.removeKey("__ok_double__");
      await common.removeKey("__ok_boolean__");
      await common.removeKey("__not_existed_key__");
      print('######################## BASIC FUNCTION TEST DONE ########################');

      String spName = FlutterStoreInstance.common.module;
      Map? result;
      result = await FlutterLightweightStorePlatform.methodChannel.invokeMethod<Map>('setString', []);
      printResult('wrong argument', result);

      /// no module or null module, will be [NSNull null] in iOS
      result = await FlutterLightweightStorePlatform.methodChannel
          .invokeMethod<Map>('setString', {'key': 'key', 'value': 'value'});
      printResult('empty module', result);
      result = await FlutterLightweightStorePlatform.methodChannel
          .invokeMethod<Map>('setString', {'module': null, 'key': 'key', 'value': 'value'});
      printResult('null module', result);

      /// no key or null key, will be [NSNull null] in iOS
      result = await FlutterLightweightStorePlatform.methodChannel
          .invokeMethod<Map>('setString', {'module': spName, 'value': 'value'});
      printResult('empty key', result);
      result = await FlutterLightweightStorePlatform.methodChannel
          .invokeMethod<Map>('setString', {'module': spName, 'key': null, 'value': 'value'});
      printResult('null key', result);

      /// no value or null value, will be [NSNull null] in iOS
      result = await FlutterLightweightStorePlatform.methodChannel
          .invokeMethod<Map>('setString', {'module': spName, 'key': 'key'});
      printResult('empty value', result);
      result = await FlutterLightweightStorePlatform.methodChannel
          .invokeMethod<Map>('setString', {'module': spName, 'key': 'key', 'value': null});
      printResult('null value', result);

      /// no correct value
      result = await FlutterLightweightStorePlatform.methodChannel
          .invokeMethod<Map>('setInt', {'module': spName, 'key': 'key', 'value': 0.223});
      printResult('wrong int value', result);
      result = await FlutterLightweightStorePlatform.methodChannel
          .invokeMethod<Map>('setInt', {'module': spName, 'key': 'key', 'value': 'not int value'});
      printResult('wrong int type', result);
      print('######################## TEST RESULT ERROR DONE ########################');
    }
  }

  void printResult(String flag, Map? map) {
    print('>>> $flag result: ${jsonEncode(map)}');
  }
}
