#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef id _Nullable(^TlValueEncoder)(id _Nullable value);
typedef id _Nullable(^TlValueDecoder)(id _Nullable value);
typedef NSString * _Nullable(^TlKeyTransformer)(NSString * _Nullable defaultName);


@interface TlStoreBase : NSObject

@property (copy, nonatomic, readonly) NSString * _Nonnull moduleName;

@property (copy, nonatomic, readonly) NSString * _Nullable aesKey;
@property (copy, nonatomic, readonly) NSString * _Nullable aesIV;

// you can change the following blocks for customize your own transformer & encoder & decoder
@property (copy, nonatomic) TlKeyTransformer _Nullable keyTransformer;
@property (copy, nonatomic) TlValueEncoder _Nullable valueEncoder;
@property (copy, nonatomic) TlValueDecoder _Nullable valueDecoder;

- (nullable instancetype)init NS_UNAVAILABLE;

- (nullable instancetype)initWithName:(NSString * _Nonnull)moduleName aesKey:(nullable NSString *)key aesIV:(nullable NSString *)iv ;

#pragma mark - Transformer

// aesKey & aesIV both setted or not indicate that encrypt/decrypt or not
- (BOOL)isEnableCrypto ;

- (nullable NSString *)encodeKey:(nullable NSString *)defaultName ;

- (nullable id)encodeValue:(nullable id)value ;

- (nullable id)decodeValue:(nullable id)value ;

@end


NS_ASSUME_NONNULL_END
