#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TlStoreManager : NSObject

+ (TlStoreManager *)instance ;

- (void)registration:(NSString * _Nonnull)module aesKey:(NSString * _Nullable)aesKey aesIV:(NSString * _Nullable)aesIV isKeepKeyClearText:(BOOL)isKeepKeyClearText ;

- (void)unregistration:(NSString * _Nonnull)module ;

- (BOOL)contains:(NSString *)module forKey:(NSString *)key ;

- (void)removeKey:(NSString *)module forKey:(NSString *)key ;

- (NSString *)getString:(NSString *)module forKey:(NSString *)key ;

- (int)getInt:(NSString *)module forKey:(NSString *)key ;

- (long)getLong:(NSString *)module forKey:(NSString *)key ;

- (float)getFloat:(NSString *)module forKey:(NSString *)key ;

- (double)getDouble:(NSString *)module forKey:(NSString *)key ;

- (BOOL)getBoolean:(NSString *)module forKey:(NSString *)key ;

- (void)setString:(NSString *)module forKey:(NSString *)key value:(NSString *)value ;

- (void)setInt:(NSString *)module forKey:(NSString *)key value:(int)value ;

- (void)setLong:(NSString *)module forKey:(NSString *)key value:(long)value ;

- (void)setFloat:(NSString *)module forKey:(NSString *)key value:(float)value ;

- (void)setDouble:(NSString *)module forKey:(NSString *)key value:(double)value ;

- (void)setBoolean:(NSString *)module forKey:(NSString *)key value:(BOOL)value ;

@end

NS_ASSUME_NONNULL_END
