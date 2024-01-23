# flutter_lightweight_store

[![pub package](https://img.shields.io/pub/v/flutter_lightweight_store.svg)](https://pub.dev/packages/flutter_lightweight_store)

A light weight key-value store (`SharedPreferences` & `NSUserdefaults`) with saving to separated customized name's `xml`/`plist` files.

Unlike the famous [shared_preferences](https://pub.dev/packages/shared_preferences) package, which only puts all key-values into the one file, `flutter_lightweight_store` package will save key-value data to the many separated files as your need.

## Usage

Please run `example/lib/main.dart` for more demonstrations

    /// 💚Create `FlutterLightweightStoreModule` instance and mark as static as you need then you can access it across the app
    
    /// 💚The key-value data will save to a file named `com.your.name.xml/plist`(Android/iOS)
    FlutterLightweightStoreModule sp = FlutterLightweightStoreModule("com.your.name");
    /// 💚More instance ... one instance corresponds to one file.
    FlutterLightweightStoreModule sp1 = FlutterLightweightStoreModule("com.file1");
    FlutterLightweightStoreModule sp2 = FlutterLightweightStoreModule("com.file2");
    FlutterLightweightStoreModule sp3 ...
    
    /// setter
    await sp.setString("string_key", "Hello world");
    await sp.setInt("int_value", 10086);
    await sp.setDouble("double_key", 10086.12306);
    await sp.setBoolean("boolean_key", true);
    
    /// getter
    var str = await sp.getString("string_key");
    var int = await sp.getInt("int_value");
    var double = await sp.getDouble("double_key");
    var boolean = await sp.getBoolean("boolean_key");

    /// remove
    await sp.removeKey('string_key');

    /// contains
    bool isContains = await sp.contains('string_key');

### Features and bugs

Please feel free to: request new features and bugs at the [issue tracker][tracker]


[tracker]: https://github.com/isaacselement/flutter_lightweight_store/issues
