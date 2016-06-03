//
//  YRDRequestGenerator.h
//  YRDGoodArc
//
//  Created by yurongde on 16/5/23.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRDRequestGenerator : NSObject
+ (instancetype)sharedInstance;
/**
 *  普通get请求
 *
 *  @param serviceIdentifier <#serviceIdentifier description#>
 *  @param requestParams     <#requestParams description#>
 *  @param methodName        <#methodName description#>
 *
 *  @return <#return value description#>
 */
- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;
/**
 *  普通Post请求
 *
 *  @param serviceIdentifier <#serviceIdentifier description#>
 *  @param requestParams     <#requestParams description#>
 *  @param methodName        <#methodName description#>
 *
 *  @return <#return value description#>
 */
- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;
/**
 *  Restful Get请求
 *
 *  @param serviceIdentifier <#serviceIdentifier description#>
 *  @param requestParams     <#requestParams description#>
 *  @param methodName        <#methodName description#>
 *
 *  @return <#return value description#>
 */
- (NSURLRequest *)generateRestfulGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;
/**
 *  Restful Post请求
 *
 *  @param serviceIdentifier <#serviceIdentifier description#>
 *  @param requestParams     <#requestParams description#>
 *  @param methodName        <#methodName description#>
 *
 *  @return <#return value description#>
 */
- (NSURLRequest *)generateRestfulPOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

@end
