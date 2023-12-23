#import <Foundation/Foundation.h>

#ifndef TlStoreProtocol_h
#define TlStoreProtocol_h

@protocol TlStoreProtocol <NSObject>

// Do Not provide api such as objectForKey:/setObject:forKey:/removeObjectForKey: to the caller

- (BOOL)contains:(nullable NSString *)defaultName;

- (void)removeKey:(nullable NSString *)defaultName;


// MARK: Getters & Setters

- (nullable NSString *)stringForKey:(nullable NSString *)defaultName;

- (NSInteger)integerForKey:(nullable NSString *)defaultName;

- (float)floatForKey:(nullable NSString *)defaultName;

- (double)doubleForKey:(nullable NSString *)defaultName;

- (BOOL)boolForKey:(nullable NSString *)defaultName;

- (void)setString:(nullable NSString *)value forKey:(nullable NSString *)defaultName;

- (void)setInteger:(NSInteger)value forKey:(nullable NSString *)defaultName;

- (void)setFloat:(float)value forKey:(nullable NSString *)defaultName;

- (void)setDouble:(double)value forKey:(nullable NSString *)defaultName;

- (void)setBool:(BOOL)value forKey:(nullable NSString *)defaultName;

@end

#endif /* TlStoreProtocol */
