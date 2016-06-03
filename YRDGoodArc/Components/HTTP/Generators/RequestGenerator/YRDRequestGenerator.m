//
//  YRDRequestGenerator.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/23.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "YRDRequestGenerator.h"
#import "YRDSignatureGenerator.h"
#import "YRDServiceFactory.h"
#import "YRDCommonParamsGenerator.h"
#import "NSDictionary+YRDNetworkingMethods.h"
#import "YRDNetworkingConfiguration.h"
#import "NSObject+YRDNetworkingMethods.h"
#import <AFNetworking/AFNetworking.h>
#import "YRDService.h"
#import "NSObject+YRDNetworkingMethods.h"
#import "YRDLogger.h"
#import "NSURLRequest+YRDNetworkingMethods.h"

@interface YRDRequestGenerator ()
@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end
@implementation YRDRequestGenerator
#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static YRDRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YRDRequestGenerator alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    YRDService *service = [[YRDServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    
    NSMutableDictionary *sigParams = [NSMutableDictionary dictionaryWithDictionary:requestParams];
    sigParams[@"api_key"] = service.publicKey;
    NSString *signature = [YRDSignatureGenerator signGetWithSigParams:sigParams methodName:methodName apiVersion:service.apiVersion privateKey:service.privateKey publicKey:service.publicKey];
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:[YRDCommonParamsGenerator commonParamsDictionary]];
    [allParams addEntriesFromDictionary:sigParams];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?%@&sig=%@", service.apiBaseUrl, service.apiVersion, methodName, [allParams YRD_urlParamsStringSignature:NO], signature];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:NULL];
    request.timeoutInterval = kYRDNetworkingTimeoutSeconds;
    request.requestParams = requestParams;
    [YRDLogger logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:@"GET"];
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    YRDService *service = [[YRDServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *signature = [YRDSignatureGenerator signPostWithApiParams:requestParams privateKey:service.privateKey publicKey:service.publicKey];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?api_key=%@&sig=%@&%@", service.apiBaseUrl, service.apiVersion, methodName, service.publicKey, signature, [[YRDCommonParamsGenerator commonParamsDictionary] YRD_urlParamsStringSignature:NO]];
    
    NSURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    [YRDLogger logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:@"POST"];
    return request;
}
- (NSURLRequest *)generateRestfulGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:[YRDCommonParamsGenerator commonParamsDictionary]];
    [allParams addEntriesFromDictionary:requestParams];
    
    YRDService *service = [[YRDServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *signature = [YRDSignatureGenerator signRestfulGetWithAllParams:allParams methodName:methodName apiVersion:service.apiVersion privateKey:service.privateKey];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?%@", service.apiBaseUrl, service.apiVersion, methodName, [allParams YRD_urlParamsStringSignature:NO]];
    
    NSDictionary *restfulHeader = [self commRESTHeadersWithService:service signature:signature];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kYRDNetworkingTimeoutSeconds];
    request.HTTPMethod = @"GET";
    [restfulHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    request.requestParams = requestParams;
    [YRDLogger logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:@"RESTful GET"];
    return request;
}


- (NSURLRequest *)generateRestfulPOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    YRDService *service = [[YRDServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSDictionary *commonParams = [YRDCommonParamsGenerator commonParamsDictionary];
    NSString *signature = [YRDSignatureGenerator signRestfulPOSTWithApiParams:requestParams commonParams:commonParams methodName:methodName apiVersion:service.apiVersion privateKey:service.privateKey];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?&%@", service.apiBaseUrl, service.apiVersion, methodName, [commonParams YRD_urlParamsStringSignature:NO]];
    
    NSDictionary *restfulHeader = [self commRESTHeadersWithService:service signature:signature];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kYRDNetworkingTimeoutSeconds];
    request.HTTPMethod = @"POST";
    [restfulHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:NSJSONWritingPrettyPrinted error:NULL];
    request.requestParams = requestParams;
    [YRDLogger logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:@"RESTful POST"];
    return request;
}
#pragma mark - private methods
- (NSDictionary *)commRESTHeadersWithService:(YRDService *)service signature:(NSString *)signature
{
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    [headerDic setValue:signature forKey:@"sig"];
    [headerDic setValue:service.publicKey forKey:@"key"];
    [headerDic setValue:@"application/json" forKey:@"Accept"];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
   
    return headerDic;
}
#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kYRDNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;

}
@end
