#import "TlStoreBase.h"
#import "EncryptorOfAES.h"


@implementation TlStoreBase

- (nullable instancetype)init {
    self = [super init];
    if (self) {
        // mark it as private using NS_UNAVAILABLE
    }
    return self;
}

- (nullable instancetype)initWithName:(NSString * _Nonnull)moduleName aesKey:(nullable NSString *)key aesIV:(nullable NSString *)iv {
    self = [super init];
    if (self) {
        _moduleName = moduleName;
        _aesKey = key;
        _aesIV = iv;
        
        if (self.isEnableCrypto) {
            __weak typeof(self) weakSelf = self;
            
            self.keyTransformer = ^NSString * _Nullable(NSString * _Nullable defaultName) {
                return [weakSelf encryptKeyIfNeeded:defaultName];
            };
            
            self.valueEncoder = ^id _Nullable(id  _Nullable value) {
                return [weakSelf encryptValueIfNeeded:value];
            };
            
            self.valueDecoder = ^id _Nullable(id  _Nullable value) {
                return [weakSelf decryptValueIfNeeded:value];
            };
        }
    }
    return self;
}


#pragma mark - Transformer

- (BOOL)isEnableCrypto {
    return self.aesKey != nil && self.aesIV != nil;
}

- (nullable NSString *)encodeKey:(nullable NSString *)defaultName {
    if (self.keyTransformer != nil && defaultName != nil) {
        return self.keyTransformer(defaultName);
    }
    return defaultName;
}

- (nullable id)encodeValue:(nullable id)value {
    if (self.valueEncoder != nil && value != nil) {
        return self.valueEncoder(value);
    }
    return value;
}

- (nullable id)decodeValue:(nullable id)value {
    if (self.valueDecoder != nil && value != nil) {
        return self.valueDecoder(value);
    }
    return value;
}


#pragma mark - AES Crypto

- (nullable NSString *)encryptKeyIfNeeded:(nullable NSString *)defaultName {
    if (self.isEnableCrypto == NO) {
        return defaultName;
    }
    if (defaultName == nil) {
        return defaultName;
    }
    NSString *name = defaultName;
    NSString *encrypted = [EncryptorOfAES encryptStrToBase64:name Key:self.aesKey IV:self.aesIV];
    if (encrypted) name = encrypted;
    return name;
}

- (nullable id)encryptValueIfNeeded:(nullable id)value {
    if (self.isEnableCrypto == NO) {
        return value;
    }
    // If value is numeric, translate NSNumber(__NSCFNumber/__NSCFBoolean) to NSString
    if ([value isKindOfClass:NSNumber.class]) {
        value = ((NSNumber *)value).stringValue;
    }
    if ([value isKindOfClass:NSString.class]) {
        NSString *encrypted = [EncryptorOfAES encryptStrToBase64:(NSString *)value Key:self.aesKey IV:self.aesIV];
        if (encrypted) value = encrypted;
    } else if ([value isKindOfClass:NSData.class]) {
        NSData *decrypted = [EncryptorOfAES encrypt:(NSData *)value Key:self.aesKey IV:self.aesIV];
        if (decrypted) value = decrypted;
    }
    return value;
}

- (nullable id)decryptValueIfNeeded:(nullable id)value {
    if (self.isEnableCrypto == NO) {
        return value;
    }
    if ([value isKindOfClass:NSString.class]) {
        NSString *decrypted = [EncryptorOfAES decryptStrFromBase64:(NSString *)value Key:self.aesKey IV:self.aesIV];
        if (decrypted) value = decrypted;
    } else if ([value isKindOfClass:NSData.class]) {
        NSData *decrypted = [EncryptorOfAES decrypt:(NSData *)value Key:self.aesKey IV:self.aesIV];
        if (decrypted) value = decrypted;
    }
    // For NSUserDefaults, if value is numeric, will be automatically traslated to numeric type by integerForKey:/floatForKey:/doubleForKey:/boolForKey:
    return value;
}


@end
