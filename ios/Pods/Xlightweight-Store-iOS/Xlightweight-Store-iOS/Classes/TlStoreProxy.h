#import <Foundation/Foundation.h>
#import "TlStoreProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TlStoreProxy : NSObject<TlStoreProtocol>

@property(strong, nonatomic) id<TlStoreProtocol> myProxy;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithName:(NSString * _Nonnull)moduleName aesKey:(nullable NSString *)key aesIV:(nullable NSString *)iv ;

@end

NS_ASSUME_NONNULL_END
