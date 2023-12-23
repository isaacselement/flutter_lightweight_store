# flutter_lightweight_store

[![pub package](https://img.shields.io/pub/v/flutter_lightweight_store.svg)](https://pub.dev/packages/flutter_lightweight_store)

A light weight key-value store (SharedPreferences & NSUserdefaults) with saving to separated/customizable xml/plist.

## Usage

Please run `example/lib/main.dart` for more demonstrations

    /// Mark this instance as static, then you can access it across the app
    /// 💚 We will save the key-value data to a file named `com.your.name.xml` on Android or `com.your.name.plist` on iOS
    FlutterLightweightStoreModule sp = FlutterLightweightStoreModule("com.your.name");
    
    /// setter
    await sp.setString("String", "Hello world");
    await sp.setInt("Int", 10086);
    await sp.setDouble("Double", 10086.12306);
    await sp.setBoolean("Boolean", true);
    
    /// getter
    var str = await sp.getString("String");
    var int = await sp.getInt("Int");
    var double = await sp.getDouble("Double");
    var boolean = await sp.getBoolean("Boolean");
    
    print('✅[SP] setter & getter: string -> $str, int -> $int, double -> $double, boolean -> $boolean');

    /// remove
    await sp.removeKey('StringKey');

    /// contains
    bool isContains = await sp.contains('StringKey');

### Features and bugs

Please feel free to: request new features and bugs at the [issue tracker][tracker]


[tracker]: https://github.com/isaacselement/flutter_lightweight_store/issues
