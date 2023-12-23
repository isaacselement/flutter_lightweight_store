#import "TlStoreProxy.h"
#import "TlUserDefaults.h"


@implementation TlStoreProxy

- (instancetype)init {
    self = [super init];
    if (self) {
        // mark it as private using NS_UNAVAILABLE
    }
    return self;
}

- (instancetype)initWithName:(NSString * _Nonnull)moduleName aesKey:(nullable NSString *)key aesIV:(nullable NSString *)iv {
    self = [super init];
    if (self) {
        self.myProxy = [[TlUserDefaults alloc] initWithName:moduleName aesKey:key aesIV:iv];
    }
    return self;
}

#pragma mark - XlStoreProtocol

- (BOOL)contains:(nullable NSString *)defaultName {
    return [self.myProxy contains:defaultName];
}

- (void)removeKey:(nullable NSString *)defaultName {
    [self.myProxy removeKey:defaultName];
}


// MARK: Primitive Values Getters & Setters


- (nullable NSString *)stringForKey:(nullable NSString *)defaultName {
    return [self.myProxy stringForKey:defaultName];
}

- (NSInteger)integerForKey:(nullable NSString *)defaultName {
    return [self.myProxy integerForKey:defaultName];
}

- (float)floatForKey:(nullable NSString *)defaultName {
    return [self.myProxy floatForKey:defaultName];
}

- (double)doubleForKey:(nullable NSString *)defaultName {
    return [self.myProxy doubleForKey:defaultName];
}

- (BOOL)boolForKey:(nullable NSString *)defaultName {
    return [self.myProxy boolForKey:defaultName];
}

- (void)setString:(nullable NSString *)value forKey:(nullable NSString *)defaultName {
    [self.myProxy setString:value forKey:defaultName];
}

- (void)setInteger:(NSInteger)value forKey:(nullable NSString *)defaultName {
    [self.myProxy setInteger:value forKey:defaultName];
}

- (void)setFloat:(float)value forKey:(nullable NSString *)defaultName {
    [self.myProxy setFloat:value forKey:defaultName];
}

- (void)setDouble:(double)value forKey:(nullable NSString *)defaultName {
    [self.myProxy setDouble:value forKey:defaultName];
}

- (void)setBool:(BOOL)value forKey:(nullable NSString *)defaultName {
    [self.myProxy setBool:value forKey:defaultName];
}

@end
