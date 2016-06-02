//
//  YRDApiProxy.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/23.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "YRDApiProxy.h"
#import "YRDServiceFactory.h"
#import "YRDRequestGenerator.h"
#import "YRDLogger.h"
#import "NSURLRequest+YRDNetworkingMethods.h"
#import "NSDictionary+YRDNetworkingMethods.h"
#import "AFNetworking.h"

static NSString * const kYRDApiProxyDispatchItemKeyCallbackSuccess = @"kYRDApiProxyDispatchItemCallbackSuccess";
static NSString * const kYRDApiProxyDispatchItemKeyCallbackFail = @"kYRDApiProxyDispatchItemCallbackFail";
@interface YRDApiProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;

//AFNetworking stuff
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end
@implementation YRDApiProxy
#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static YRDApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YRDApiProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(YRDCallback)success fail:(YRDCallback)fail
{
    NSURLRequest *request = [[YRDRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(YRDCallback)success fail:(YRDCallback)fail
{
    NSURLRequest *request = [[YRDRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callRestfulGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(YRDCallback)success fail:(YRDCallback)fail
{
    NSURLRequest *request = [[YRDRequestGenerator sharedInstance] generateRestfulGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callRestfulPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(YRDCallback)success fail:(YRDCallback)fail
{
    NSURLRequest *request = [[YRDRequestGenerator sharedInstance] generateRestfulPOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *task = self.dispatchTable[requestID];
    [task cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

#pragma mark - private methods
/** 这个函数存在的意义在于，如果将来要把AFNetworking换掉，只要修改这个函数的实现即可。 */
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(YRDCallback)success fail:(YRDCallback)fail
{
    // 之所以不用getter，是因为如果放到getter里面的话，每次调用self.recordedRequestId的时候值就都变了，违背了getter的初衷
    NSNumber *requestId = [self generateRequestId];
    
    // 跑到这里的block的时候，就已经是主线程了。
    __weak typeof(&*self) weakSelf = self;
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        __strong typeof(&*weakSelf) strongSelf = weakSelf;
        NSURLSessionDataTask *storedTask = strongSelf.dispatchTable[requestId];
        if (storedTask == nil) {
            // 如果这个operation是被cancel的，那就不用处理回调了。
            return;
        }else{
            [strongSelf.dispatchTable removeObjectForKey:requestId];
        }
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (!error) {
            
            // success
            
            [YRDLogger logDebugInfoWithResponse:(NSHTTPURLResponse*)response
                                  resposeString:responseString
                                        request:request
                                          error:NULL];
            
            YRDURLResponse *response = [[YRDURLResponse alloc] initWithResponseString:responseString
                                                                            requestId:requestId
                                                                              request:request
                                                                         responseData:responseObject
                                                                               status:YRDURLResponseStatusSuccess];
            success?success(response):nil;
        }else{
            [YRDLogger logDebugInfoWithResponse:(NSHTTPURLResponse*)response
                                  resposeString:responseString
                                        request:request
                                          error:error];
            
            YRDURLResponse *response = [[YRDURLResponse alloc] initWithResponseString:responseString
                                                                            requestId:requestId
                                                                              request:request
                                                                         responseData:responseObject
                                                                                error:error];
            fail?fail(response):nil;
        }
    }];
    
    self.dispatchTable[requestId] = task;
    [task resume];
    return requestId;
}

- (NSNumber *)generateRequestId
{
    if (_recordedRequestId == nil) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}
#pragma mark - getters and setters
- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _sessionManager;
}

@end
