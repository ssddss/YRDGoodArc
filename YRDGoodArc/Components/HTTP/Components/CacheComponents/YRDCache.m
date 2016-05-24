//
//  YRDCache.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/23.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "YRDCache.h"
#import "NSDictionary+YRDNetworkingMethods.h"
#import "YRDNetworkingConfiguration.h"


@interface YRDCache()
@property (nonatomic, strong) NSCache *cache;

@end
@implementation YRDCache
#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static YRDCache *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YRDCache alloc] init];
    });
    return sharedInstance;
}
#pragma mark - public method
- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier
                                      methodName:(NSString *)methodName
                                   requestParams:(NSDictionary *)requestParams
{
    return [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)saveCacheWithData:(NSData *)cachedData
        serviceIdentifier:(NSString *)serviceIdentifier
               methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    [self saveCacheWithData:cachedData key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                              methodName:(NSString *)methodName
                           requestParams:(NSDictionary *)requestParams
{
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (NSData *)fetchCachedDataWithKey:(NSString *)key {
    YRDCachedObject *cacheObject = [self.cache objectForKey:key];
    if (cacheObject.isOutdated || cacheObject.isEmpty) {
        return nil;
    }
    else {
        return cacheObject.content;
    }
}

- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key {
    YRDCachedObject *cacheObject = [self.cache objectForKey:key];
    if (!cacheObject) {
        cacheObject = [[YRDCachedObject alloc]init];
    }
    
    [cacheObject updateContent:cachedData];
    [self.cache setObject:cacheObject forKey:key];
}
- (void)deleteCacheWithKey:(NSString *)key {
    [self.cache removeObjectForKey:key];
}
- (void)clean {
    [self.cache removeAllObjects];
}

- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams {
    return [NSString stringWithFormat:@"%@%@%@",serviceIdentifier,methodName,[requestParams YRD_urlParamsStringSignature:NO]];
}
#pragma mark - getters and setters
- (NSCache *)cache
{
    if (_cache == nil) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = kYRDCacheCountLimit;
    }
    return _cache;
}
@end
