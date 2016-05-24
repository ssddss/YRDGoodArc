//
//  YRDCache.h
//  YRDGoodArc
//
//  Created by yurongde on 16/5/23.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRDCachedObject.h"
@interface YRDCache : NSObject
+ (instancetype)sharedInstance;

/**
 *  获取key的生成方式
 *
 *  @param serviceIdentifier <#serviceIdentifier description#>
 *  @param methodName        <#methodName description#>
 *  @param requestParams     <#requestParams description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier
                            methodName:(NSString *)methodName
                         requestParams:(NSDictionary *)requestParams;


/**
 *  查找出缓存内容
 *
 *  @param serviceIdentifier <#serviceIdentifier description#>
 *  @param methodName        <#methodName description#>
 *  @param requestParams     <#requestParams description#>
 *
 *  @return <#return value description#>
 */
- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier
                                      methodName:(NSString *)methodName
                                   requestParams:(NSDictionary *)requestParams;
/**
 *  保存
 *
 *  @param cachedData        <#cachedData description#>
 *  @param serviceIdentifier <#serviceIdentifier description#>
 *  @param methodName        <#methodName description#>
 *  @param requestParams     <#requestParams description#>
 */
- (void)saveCacheWithData:(NSData *)cachedData
        serviceIdentifier:(NSString *)serviceIdentifier
               methodName:(NSString *)methodName
            requestParams:(NSDictionary *)requestParams;
/**
 *  删除
 *
 *  @param serviceIdentifier <#serviceIdentifier description#>
 *  @param methodName        <#methodName description#>
 *  @param requestParams     <#requestParams description#>
 */
- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                              methodName:(NSString *)methodName
                           requestParams:(NSDictionary *)requestParams;


/**
 *  真正的查询操作
 *
 *  @param key <#key description#>
 *
 *  @return <#return value description#>
 */
- (NSData *)fetchCachedDataWithKey:(NSString *)key;
/**
 *  真正的保存
 *
 *  @param cachedData <#cachedData description#>
 *  @param key        <#key description#>
 */
- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key;
/**
 *  直正的删除
 *
 *  @param key <#key description#>
 */
- (void)deleteCacheWithKey:(NSString *)key;
/**
 *  清除所有
 */
- (void)clean;
@end
