#import "TlUserFiles.h"

@interface TlUserFiles()

@property (copy, nonatomic) NSString *directory;

@end


@implementation TlUserFiles


- (nullable instancetype)initWithName:(NSString * _Nonnull)moduleName aesKey:(nullable NSString *)key aesIV:(nullable NSString *)iv {
    self = [super initWithName:moduleName aesKey:key aesIV:iv];
    if (self) {
        self.directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:moduleName];
    }
    return self;
}


#pragma mark - XlStoreProtocol


- (BOOL)contains:(nullable NSString *)defaultName {
    return [self isKeyExisted:defaultName];
}

- (void)removeKey:(nullable NSString *)defaultName {
    [self setValueToFile:nil forKey:defaultName];
}

- (BOOL)boolForKey:(nullable NSString *)defaultName {
    NSString *value = [self stringForKey:defaultName];
    return [value boolValue];
}

- (double)doubleForKey:(nullable NSString *)defaultName { 
    NSString *value = [self stringForKey:defaultName];
    return [value doubleValue];
}

- (float)floatForKey:(nullable NSString *)defaultName { 
    NSString *value = [self stringForKey:defaultName];
    return [value floatValue];
}

- (NSInteger)integerForKey:(nullable NSString *)defaultName { 
    NSString *value = [self stringForKey:defaultName];
    return [value integerValue];
}

- (void)setBool:(BOOL)value forKey:(nullable NSString *)defaultName { 
    [self setString:@(value).stringValue forKey:defaultName];
}

- (void)setDouble:(double)value forKey:(nullable NSString *)defaultName { 
    [self setString:@(value).stringValue forKey:defaultName];
}

- (void)setFloat:(float)value forKey:(nullable NSString *)defaultName { 
    [self setString:@(value).stringValue forKey:defaultName];
}

- (void)setInteger:(NSInteger)value forKey:(nullable NSString *)defaultName { 
    [self setString:@(value).stringValue forKey:defaultName];
}

- (void)setString:(nullable NSString *)value forKey:(nullable NSString *)defaultName { 
    if (defaultName == nil) return;;
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    [self setValueToFile:data forKey:defaultName];
}

- (nullable NSString *)stringForKey:(nullable NSString *)defaultName { 
    if (defaultName == nil) return nil;
    NSData *data = [self getValueFromFile:defaultName];
    if (data == nil) return nil;
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


#pragma mark - Write to File: create one file for every key

- (BOOL)isKeyExisted:(NSString *)key {
    NSString *fileName = [self encodeKey:key];
    if (fileName == nil) return NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:[self fullPath:fileName]];
}

- (BOOL)setValueToFile:(NSData *)value forKey:(NSString *)key {
    NSString *name = key;
    name = [self encodeKey:name];
    if (name == nil) return nil;
    NSString *filePath = [self fullPath:name];
    
    BOOL isSuccess = NO;
    NSError *error = nil;
    if (value == nil) {
        // delete the file
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            isSuccess = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if (isSuccess == NO) NSLog(@"Delete file failed: %@, %@", filePath, error);
        } else {
            isSuccess = YES;
        }
    } else {
        // write to file
        value = [self encodeValue:value];
        isSuccess = [value writeToFile:filePath options:NSDataWritingAtomic error:&error];
        if (isSuccess == NO) NSLog(@"Write data to file failed: %@, %@", filePath, error);
    }
    return isSuccess;
}

- (NSData *)getValueFromFile:(NSString *)key {
    NSString *name = key;
    name = [self encodeKey:name];
    if (name == nil) return nil;
    NSString *filePath = [self fullPath:name];
    
    NSData *value = [[NSData alloc] initWithContentsOfFile:filePath];
    id object = [self decodeValue:value];
    return object;
}

- (NSString *)fullPath:(NSString *)fileName {
    NSString *parent = self.directory;
    if ([[NSFileManager defaultManager] fileExistsAtPath:parent] == NO) {
        NSError *error = nil;
        BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:parent withIntermediateDirectories:YES attributes:nil error:&error];
        if (isSuccess == NO) {
            NSLog(@"Create directory failed: %@, %@", parent, error);
        }
    }
    NSString *path = [parent stringByAppendingPathComponent:fileName];
    return path;
}

@end
