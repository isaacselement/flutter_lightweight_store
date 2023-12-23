#import "TlStoreManager.h"
#import "TlStoreProxy.h"
#import "TlStoreBase.h"


@interface TlStoreManager()

@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableDictionary *> *mSpecs;

@property (strong, nonatomic) NSMutableDictionary<NSString *, id<TlStoreProtocol>> *mStores;

@end


@implementation TlStoreManager

+ (TlStoreManager *)instance {
    static TlStoreManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[TlStoreManager alloc] init];
        }
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.mSpecs = [NSMutableDictionary dictionary];
        self.mStores = [NSMutableDictionary dictionary];
    }
    return self;
}

/**
 * Initial methods
 */

- (void)registration:(NSString * _Nonnull)module aesKey:(NSString * _Nullable)aesKey aesIV:(NSString * _Nullable)aesIV isKeepKeyClearText:(BOOL)isKeepKeyClearText {
    NSMutableDictionary *spec = [NSMutableDictionary dictionary];
    if (aesKey != nil) [spec setObject:aesKey forKey:@"aesKey"];
    if (aesIV != nil) [spec setObject:aesIV forKey:@"aesIV"];
    if (isKeepKeyClearText == TRUE) [spec setObject:@(TRUE) forKey:@"isKeepKeyClearText"];
    [self.mSpecs setObject:spec forKey:module];
}

- (id<TlStoreProtocol> _Nullable)assureExisted:(NSString * _Nonnull)module {
    if (module == nil) return nil;
    NSMutableDictionary *spec = [self.mSpecs objectForKey:module];
    if (spec == nil) return nil;
    id<TlStoreProtocol> store = [self.mStores objectForKey:module];
    if (store == nil) {
        NSString *aesKey = [spec objectForKey:@"aesKey"];
        NSString *aesIV = [spec objectForKey:@"aesIV"];
        BOOL isKeepKeyClearText = [[spec objectForKey:@"isKeepKeyClearText"] boolValue];
        store = [[TlStoreProxy alloc] initWithName:module aesKey:aesKey aesIV:aesIV];
        [self.mStores setObject:store forKey:module];
        
        if (isKeepKeyClearText && [((TlStoreProxy *)store).myProxy isKindOfClass:TlStoreBase.class]) {
            TlStoreBase *sp = (TlStoreBase *)((TlStoreProxy *)store).myProxy;
            sp.keyTransformer = nil;
        }
    }
    return store;
}

- (void)unregistration:(NSString * _Nonnull)module {
    if (module == nil) return;
    [self.mStores removeObjectForKey:module];
}

/**
 * Key-Value methods
 */

- (BOOL)contains:(NSString *)module forKey:(NSString *)key {
    id<TlStoreProtocol> sp = [self assureExisted:module];
    if (sp == nil) return NO;
    return [sp contains:key];
}

- (void)removeKey:(NSString *)module forKey:(NSString *)key {
    id<TlStoreProtocol> sp = [self assureExisted:module];
    if (sp == nil) return;
    [sp removeKey:key];
}

- (NSString *)getString:(NSString *)module forKey:(NSString *)key {
    id<TlStoreProtocol> sp = [self assureExisted:module];
    if (sp == nil) return nil;
    return [sp stringForKey:key];
}

- (int)getInt:(NSString *)module forKey:(NSString *)key {
    id<TlStoreProtocol> sp = [self assureExisted:module];
    if (sp == nil) return 0;
    return (int)[sp integerForKey:key];
}

- (long)getLong:(NSString *)module forKey:(NSString *)key {
    id<TlStoreProtocol> sp = [self assureExisted:module];
    if (sp == nil) return 0l;
    return [sp integerForKey:key];
}

- (float)getFloat:(NSString *)module forKey:(NSString *)key {
    id<TlStoreProtocol> sp = [self assureExisted:module];
    if (sp == nil) return 0.0f;
    return [sp floatForKey:key];
}

- (double)getDouble:(NSString *)module forKey:(NSString *)key {
    id<TlStoreProtocol> sp = [self assureExisted:module];
    if (sp == nil) return 0.0;
    return [sp doubleForKey:key];
}

- (BOOL)getBoolean:(NSString *)module forKey:(NSString *)key {
    id<TlStoreProtocol> sp = [self assureExisted:module];
    if (sp == nil) return FALSE;
    return [sp boolForKey:key];
}

- (void)setString:(NSString *)module forKey:(NSString *)key value:(NSString *)value {
    id<TlStoreProtocol> sp = [self assureExisted:module];
    if (sp == nil) return;
    [sp setString:value forKey:key];
}

- (void)setInt:(NSString *)module forKey:(NSString *)key value:(int)value {
    id<TlStoreProtocol> sp = [self assureExisted:module];
    if (sp == nil) return;
    [sp setInteger:value forKey:key];
}

- (void)setLong:(NSString *)module forKey:(NSString *)key value:(long)value {
    id<TlStoreProtocol> sp = [self assureExisted:module];
    if (sp == nil) return;
    [sp setInteger:value forKey:key];
}

- (void)setFloat:(NSString *)module forKey:(NSString *)key value:(float)value {
    id<TlStoreProtocol> sp = [self assureExisted:module];
    if (sp == nil) return;
    [sp setFloat:value forKey:key];
}

- (void)setDouble:(NSString *)module forKey:(NSString *)key value:(double)value {
    id<TlStoreProtocol> sp = [self assureExisted:module];
    if (sp == nil) return;
    [sp setDouble:value forKey:key];
}

- (void)setBoolean:(NSString *)module forKey:(NSString *)key value:(BOOL)value {
    id<TlStoreProtocol> sp = [self assureExisted:module];
    if (sp == nil) return;
    [sp setBool:value forKey:key];
}

@end
