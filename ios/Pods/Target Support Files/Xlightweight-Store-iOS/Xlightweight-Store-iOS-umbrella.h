#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "EncryptorOfAES.h"
#import "NSData+Base64.h"
#import "NSData+CommonCrypto.h"
#import "TlStoreBase.h"
#import "TlUserDefaults.h"
#import "TlUserFiles.h"
#import "TlStoreManager.h"
#import "TlStoreProtocol.h"
#import "TlStoreProxy.h"

FOUNDATION_EXPORT double Xlightweight_Store_iOSVersionNumber;
FOUNDATION_EXPORT const unsigned char Xlightweight_Store_iOSVersionString[];

