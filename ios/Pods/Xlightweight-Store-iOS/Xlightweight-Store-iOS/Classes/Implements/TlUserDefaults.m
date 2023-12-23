#import "TlUserDefaults.h"
#import "EncryptorOfAES.h"


/// MARK: Class _InternalUserDefaults

@interface _InternalUserDefaults: NSUserDefaults

@property (weak) TlUserDefaults *delegate;

@end

@implementation _InternalUserDefaults


#pragma mark - Override

- (nullable id)objectForKey:(NSString *)defaultName {
    NSString *name = defaultName;
    name = [self.delegate encodeKey:name];
    if (name == nil) return nil;
    id value = [super objectForKey:name];    // call super, be careful of recursion
    id object = [self.delegate decodeValue:value];
    return object;
}

- (void)setObject:(nullable id)object forKey:(NSString *)defaultName {
    id value = object;
    NSString *name = defaultName;
    name = [self.delegate encodeKey:name];
    if (name == nil) return;
    if (value != nil) {
        value = [self.delegate encodeValue:value];
    }
    [super setObject:value forKey:name];     // call super, be careful of recursion
}

@end


/// MARK: Class TlUserDefaults

@interface TlUserDefaults()

@property (strong, nonatomic) NSUserDefaults *internalUserDefaults;

@end


@implementation TlUserDefaults

- (nullable instancetype)initWithName:(NSString * _Nonnull)moduleName aesKey:(nullable NSString *)key aesIV:(nullable NSString *)iv {
    if (self = [super initWithName:moduleName aesKey:key aesIV:iv]) {
        // if name == nil, the instance is differ from [NSUserDefaults standardUserDefaults]
        // but they save content to the same file Library/Preferences/[bundle.id].plist
        self.internalUserDefaults = [[_InternalUserDefaults alloc] initWithSuiteName:moduleName];
        ((_InternalUserDefaults *)self.internalUserDefaults).delegate = self;
    }
    return self;
}


#pragma mark - Extra APIs Copied From NSUserDefaults.h, do not export now ...

/*
- (nullable NSArray *)arrayForKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return nil;
    return [self.userDefaults arrayForKey:defaultName];
}

- (nullable NSDictionary<NSString *, id> *)dictionaryForKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return nil;
    return [self.userDefaults dictionaryForKey:defaultName];;
}

- (nullable NSData *)dataForKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return nil;
    return [self.userDefaults dataForKey:defaultName];
}

- (nullable NSArray<NSString *> *)stringArrayForKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return nil;
    return [self.userDefaults stringArrayForKey:defaultName];
}

- (nullable NSURL *)URLForKey:(NSString *)defaultName {
    if (defaultName == nil) return nil;
    return [self.userDefaults URLForKey:defaultName];
}

- (void)setURL:(nullable NSURL *)url forKey:(NSString *)defaultName {
    if (defaultName == nil) return;
    [self.userDefaults setURL:url forKey:defaultName];
}
 */

- (nullable id)objectForKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return nil;
    return [self.internalUserDefaults objectForKey:defaultName];
}

- (void)setObject:(nullable id)value forKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return;
    [self.internalUserDefaults setObject:value forKey:defaultName];
}

/// -removeObjectForKey: is equivalent to -[... setObject:nil forKey:defaultName]
- (void)removeObjectForKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return;
    [self.internalUserDefaults removeObjectForKey:defaultName];
}


#pragma mark - XlStoreProtocol

- (BOOL)contains:(nullable NSString *)defaultName {
    return [self objectForKey:defaultName] != nil;
}

- (void)removeKey:(nullable NSString *)defaultName {
    [self removeObjectForKey:defaultName];
}

- (nullable NSString *)stringForKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return nil;
    return [self.internalUserDefaults stringForKey:defaultName];
}

- (NSInteger)integerForKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return 0l;      // NOTE: lowcase L, not a digital 1.
    return [self.internalUserDefaults integerForKey:defaultName];
}

- (float)floatForKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return 0.0f;
    return [self.internalUserDefaults floatForKey:defaultName];
}

- (double)doubleForKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return 0.0l;    // NOTE: lowcase L, not a digital 1.
    return [self.internalUserDefaults doubleForKey:defaultName];
}

- (BOOL)boolForKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return NO;
    return [self.internalUserDefaults boolForKey:defaultName];
}

- (void)setString:(nullable NSString *)value forKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return;
    [self.internalUserDefaults setObject:value forKey:defaultName];
}

- (void)setInteger:(NSInteger)value forKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return;
    [self.internalUserDefaults setInteger:value forKey:defaultName];
}

- (void)setFloat:(float)value forKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return;
    [self.internalUserDefaults setFloat:value forKey:defaultName];
}

- (void)setDouble:(double)value forKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return;
    [self.internalUserDefaults setDouble:value forKey:defaultName];
}

- (void)setBool:(BOOL)value forKey:(nullable NSString *)defaultName {
    if (defaultName == nil) return;
    [self.internalUserDefaults setBool:value forKey:defaultName];
}

@end
