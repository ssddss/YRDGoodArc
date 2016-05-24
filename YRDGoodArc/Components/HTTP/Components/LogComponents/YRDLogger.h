//
//  YRDLogger.h
//  YRDGoodArc
//
//  Created by yurongde on 16/5/23.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRDService.h"
#import "YRDLoggerConfiguration.h"
#import "YRDURLResponse.h"
@interface YRDLogger : NSObject
@property (nonatomic, strong, readonly) YRDLoggerConfiguration *configParams;
/**
 *  打印请求信息
 *
 *  @param request       <#request description#>
 *  @param apiName       <#apiName description#>
 *  @param service       <#service description#>
 *  @param requestParams <#requestParams description#>
 *  @param httpMethod    <#httpMethod description#>
 */
+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(YRDService *)service requestParams:(id)requestParams httpMethod:(NSString *)httpMethod;
/**
 *  打印请求结果
 *
 *  @param response       <#response description#>
 *  @param responseString <#responseString description#>
 *  @param request        <#request description#>
 *  @param error          <#error description#>
 */
+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response resposeString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;
/**
 *  打印缓存请求结果
 *
 *  @param response   <#response description#>
 *  @param methodName <#methodName description#>
 *  @param service    <#service description#>
 */
+ (void)logDebugInfoWithCachedResponse:(YRDURLResponse *)response methodName:(NSString *)methodName serviceIdentifier:(YRDService *)service;

+ (instancetype)sharedInstance;
- (void)logWithActionCode:(NSString *)actionCode params:(NSDictionary *)params;
@end
