#import "FlutterLightweightStorePlugin.h"
#import "TlStoreManager.h"

#import "EncryptorOfAES.h"

@implementation FlutterLightweightStorePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"flutter_lightweight_store" binaryMessenger:[registrar messenger]];
    FlutterLightweightStorePlugin* instance = [[FlutterLightweightStorePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}


- (void)resultFailed:(FlutterResult)result errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
    result(@{@"code": @(errorCode), @"error": errorMsg ?: @""});
}

#define kFailedResult(_result, _code, _msg) [self resultFailed:_result errorCode:_code errorMsg:_msg]

- (void)resultSuccess:(FlutterResult)result data:(nullable id)data {
    if (result == nil) return;
    if (data == nil) {
        result(@{@"code": @(200)});
    } else {
        result(@{@"code": @(200), @"data": data});
    }
}

#define kSuccessResult(_result, _data) [self resultSuccess:_result data:_data]


# pragma mark - Override Methods
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *method = call.method;
    id arguments = call.arguments;
    if (![arguments isKindOfClass:NSDictionary.class]) {
        kFailedResult(result, 3000300, @"arguments type should be a hash map.");
        return;
    }
    NSDictionary *args = arguments;
    
    @try {
        [self handleMethod:method arguments:args result:result];
    } @catch (NSException *exception) {
        kFailedResult(result, 3000301, [exception description]);
    } @finally {
        // nothing now ...
    }
}

- (void)handleMethod:(NSString * _Nonnull)method arguments:(NSDictionary * _Nonnull)arguments result:(FlutterResult)result {
    NSString *module = [arguments objectForKey:@"module"];
    if (module == nil || module.length == 0) {
        kFailedResult(result, 3000302, @"arguments should have a 'module' KV.");
        return;
    }
    
    if ([method isEqualToString:@"register"]) {
        NSString *aesKey = [arguments objectForKey:@"aesKey"];
        NSString *aesIV = [arguments objectForKey:@"aesIV"];
        BOOL isKeepKeyClearText = [[arguments objectForKey:@"isKeepKeyClearText"] boolValue];
        
        [TlStoreManager.instance registration:module aesKey:aesKey aesIV:aesIV isKeepKeyClearText:isKeepKeyClearText];
        kSuccessResult(result, nil);
        return;
    }
    
    if ([method isEqualToString:@"unregister"]) {
        [TlStoreManager.instance unregistration:module];
        kSuccessResult(result, nil);
        return;
    }
    
    NSString *key = [arguments objectForKey:@"key"];
    if (key == nil || key.length == 0) {
        kFailedResult(result, 3000303, @"arguments should have a 'key' KV in get* method.");
        return;
    }
    
    if ([method isEqualToString:@"contains"]) {
        BOOL retValue = [TlStoreManager.instance contains:module forKey:key];
        kSuccessResult(result, @(retValue));
        return;
    }
    
    if ([method isEqualToString:@"removeKey"]) {
        [TlStoreManager.instance removeKey:module forKey:key];
        BOOL retValue = YES;
        kSuccessResult(result, @(retValue));
        return;
    }
    
    // getter
    if ([method isEqualToString:@"getString"]) {
        NSString *retValue = [TlStoreManager.instance getString:module forKey:key];
        kSuccessResult(result, retValue);
        return;
    }
    
    if ([method isEqualToString:@"getInt"] || [method isEqualToString:@"getLong"]) {
        long retValue = [TlStoreManager.instance getLong:module forKey:key];
        BOOL isKeyExisted = YES;
        if (retValue == 0) {
            isKeyExisted = [TlStoreManager.instance contains:module forKey:key];
        }
        kSuccessResult(result, isKeyExisted ? @(retValue) : nil);
        return;
    }
    
    if ([method isEqualToString:@"getFloat"] || [method isEqualToString:@"getDouble"]) {
        double retValue = [TlStoreManager.instance getDouble:module forKey:key];
        BOOL isKeyExisted = YES;
        if (retValue == 0.0) {
            isKeyExisted = [TlStoreManager.instance contains:module forKey:key];
        }
        kSuccessResult(result, isKeyExisted ? @(retValue) : nil);
        return;
    }
    
    if ([method isEqualToString:@"getBoolean"]) {
        BOOL retValue = [TlStoreManager.instance getBoolean:module forKey:key];
        BOOL isKeyExisted = YES;
        if (retValue == FALSE) {
            isKeyExisted = [TlStoreManager.instance contains:module forKey:key];
        }
        kSuccessResult(result, isKeyExisted ? @(retValue) : nil);
        return;
    }
    
    
    NSObject *value = [arguments objectForKey:@"value"];
    if (value == nil) {
        kFailedResult(result, 3000304, @"arguments should have a 'value' KV in set* method.");
        return;
    }
    
    // setter
    if ([method isEqualToString:@"setString"]) {
        NSString *setVal = nil;
        if ([value isKindOfClass:NSString.class]) {
            setVal = (NSString *) value;
        } else if ([value isKindOfClass:NSNumber.class]) {
            setVal = [(NSNumber *)value stringValue];
        } else {
            setVal = [value description];
        }
        [TlStoreManager.instance setString:module forKey:key value:setVal];
        kSuccessResult(result, nil);
        return;
    }
    
    if ([method isEqualToString:@"setInt"] || [method isEqualToString:@"setLong"]) {
        long setVal = 0;
        if ([value isKindOfClass:NSString.class]) {
            setVal = [(NSString *)value integerValue];
        } else if ([value isKindOfClass:NSNumber.class]) {
            setVal = [(NSNumber *)value integerValue];
        } else {
            kFailedResult(result, -1, @"value not a int/long value");
            return;
        }
        [TlStoreManager.instance setLong:module forKey:key value:setVal];
        kSuccessResult(result, nil);
        return;
    }
    
    if ([method isEqualToString:@"setFloat"] || [method isEqualToString:@"setDouble"]) {
        double setVal = 0;
        if ([value isKindOfClass:NSString.class]) {
            setVal = [(NSString *)value doubleValue];
        } else if ([value isKindOfClass:NSNumber.class]) {
            setVal = [(NSNumber *)value doubleValue];
        } else {
            kFailedResult(result, -1, @"value not a float/double value");
            return;
        }
        [TlStoreManager.instance setDouble:module forKey:key value:setVal];
        kSuccessResult(result, nil);
        return;
    }
    
    if ([method isEqualToString:@"setBoolean"]) {
        BOOL setVal = 0;
        if ([value isKindOfClass:NSString.class]) {
            setVal = [(NSString *)value boolValue];
        } else if ([value isKindOfClass:NSNumber.class]) {
            setVal = [(NSNumber *)value boolValue];
        } else {
            kFailedResult(result, -1, @"value not a boolean value");
            return;
        }
        [TlStoreManager.instance setBoolean:module forKey:key value:setVal];
        kSuccessResult(result, nil);
        return;
    }
    
    // TODO ... Remove the following code after several versions
    if ([method isEqualToString:@"restoreEmptyAesKeyIvContents"]) {
        NSUserDefaults *user = [[NSUserDefaults alloc] initWithSuiteName:module];
        if ([user objectForKey:@"__already_restored__"] == nil) {
            [user setObject:@(YES) forKey:@"__already_restored__"];

            NSDictionary<NSString *, id> *allKeysValues = [user dictionaryRepresentation];
            NSArray<NSString *> *allKeys = allKeysValues.allKeys;

            for (NSString *key in allKeys) {
                if ([key hasPrefix:@"Apple"]) continue;
                id value = [allKeysValues valueForKey:key];
                if (![value isKindOfClass:NSString.class]) continue;

                NSString *deKey = [self emptyAesKeyIvDecrypt:key];
                NSString *deValue = [self emptyAesKeyIvDecrypt:value];
                NSLog(@"Key: %@, Value: %@. De-key: %@, De-value: %@", key, value, deKey, deValue);
                if (deKey == nil || deValue == nil) continue;
                [user setObject:deValue forKey:deKey];
            }
        }

        kSuccessResult(result, nil);
        return;
    }

    result(FlutterMethodNotImplemented);
}

- (NSString *)emptyAesKeyIvEncrypt: (NSString *)content {
    return [EncryptorOfAES encryptToBase64:[content dataUsingEncoding:NSUTF8StringEncoding] Key:@"" IV:@""];
}

- (NSString *)emptyAesKeyIvDecrypt: (NSString *)content {
    return [[NSString alloc] initWithData:[EncryptorOfAES decryptFromBase64:content Key:@"" IV:@""] encoding:NSUTF8StringEncoding];
}

@end
