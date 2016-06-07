//
//  YRDAPIBaseManager.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/23.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "YRDAPIBaseManager.h"
#import "YRDNetworking.h"
#import "YRDCache.h"
#import "YRDLogger.h"
#import "YRDServiceFactory.h"

#define YRDCallAPI(REQUEST_METHOD, REQUEST_ID)                                                       \
{          __weak typeof(&*self) weakSelf = self;                                                                  \
REQUEST_ID = [[YRDApiProxy sharedInstance] call##REQUEST_METHOD##WithParams:apiParams serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:^(YRDURLResponse *response) { \
 __strong typeof(&*weakSelf) strongSelf = weakSelf;                 \
[strongSelf successedOnCallingAPI:response];                                          \
} fail:^(YRDURLResponse *response) {                                                \
 __strong typeof(&*weakSelf) strongSelf = weakSelf;                             \
[strongSelf failedOnCallingAPI:response withErrorType:YRDAPIManagerErrorTypeDefault];  \
}];                                                                                 \
[self.requestIdList addObject:@(REQUEST_ID)];                                          \
}

@interface YRDAPIBaseManager ()

@property (nonatomic, strong, readwrite) id fetchedRawData;

@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, readwrite) YRDAPIManagerErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, strong) YRDCache *cache;
@end
@implementation YRDAPIBaseManager
#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        
        _fetchedRawData = nil;
        
        _errorMessage = nil;
        _errorType = YRDAPIManagerErrorTypeDefault;
        
        //一定要实现这个代理，提供参数
        if ([self conformsToProtocol:@protocol(YRDAPIManager)]) {
            self.child = (id <YRDAPIManager>)self;
        }
        else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
       
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - public methods
- (void)cancelAllRequests {
    [[YRDApiProxy sharedInstance]cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
    [self clearCompletionBlock];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID {
  
    
    [self removeRequestIdWithRequestID:requestID];
    [[YRDApiProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
    [self clearCompletionBlock];
    
}
- (id)fetchDataWithReformer:(id<YRDAPIManagerCallbackDataReformer>)reformer {
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    }
    else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}
#pragma mark - calling API

- (void)startWithCompletionBlockWithSuccess:(YRDRequestCompletionBlock)success failure:(YRDRequestCompletionBlock)failure {
   
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self loadData];
}
- (void)setCompletionBlockWithSuccess:(YRDRequestCompletionBlock)success
                              failure:(YRDRequestCompletionBlock)failure {
    [self clearCompletionBlock];
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
//    最好还是使用weakSelf
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}
- (NSInteger)loadData {
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
    
}
- (NSInteger)loadDataWithParams:(NSDictionary *)params {
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    if ([self shouldCallAPIWithParams:apiParams]) {
        if ([self.validator manager:self isCorrectWithParamsData:apiParams]) {
            
             // 先检查一下是否有缓存
            if ([self shouldCache] && [self hasCacheWithParams:apiParams]) {
                return 0;
            }
            // 实际的网络请求
            if ([self isReachable]) {
                switch (self.child.requestType) {
                    case YRDAPIManagerRequestTypeGet: {
                        YRDCallAPI(GET, requestId);
                        break;
                    }
                    case YRDAPIManagerRequestTypePost: {
                        YRDCallAPI(POST, requestId);
                        break;
                    }
                    case YRDAPIManagerRequestTypeRestGet: {
                        YRDCallAPI(RestfulGET, requestId);
                        break;
                    }
                    case YRDAPIManagerRequestTypeRestPost: {
                        YRDCallAPI(RestfulPOST, requestId);
                        break;
                    }
                }
                
                //发出请求之后 的请求参数
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params addEntriesFromDictionary:apiParams];
                params[kYRDAPIBaseManagerRequestID] = @(requestId);
                [self afterCallingAPIWithParams:params];
                return requestId;

            }
            else {
                [self failedOnCallingAPI:nil withErrorType:YRDAPIManagerErrorTypeNoNetWork];
                return requestId;
            }
        }
        else {
            [self failedOnCallingAPI:nil withErrorType:YRDAPIManagerErrorTypeParamsError];
            return requestId;
        }
    }
    return requestId;
}
#pragma mark - api callbacks
- (void)apiCallBack:(YRDURLResponse *)response
{
    if (response.status == YRDURLResponseStatusSuccess) {
        [self successedOnCallingAPI:response];
    }else{
        [self failedOnCallingAPI:response withErrorType:YRDAPIManagerErrorTypeTimeout];
    }
}
- (void)successedOnCallingAPI:(YRDURLResponse *)response {
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    }
    else {
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        
        if ([self shouldCache] && !response.isCache) {
            [self.cache saveCacheWithData:response.responseData serviceIdentifier:self.child.serviceType methodName:self.child.methodName requestParams:response.requestParams];
        }
        
        [self beforePerformSuccessWithResponse:response];
        //代理回调
        if ([self.delegate respondsToSelector:@selector(managerCallAPIDidSuccess:)]) {
            [self.delegate managerCallAPIDidSuccess:self];
        }
        //block回调
        !self.successCompletionBlock?:self.successCompletionBlock(self);
        
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:YRDAPIManagerErrorTypeNoContent];
    }
    
    [self clearCompletionBlock];
}
- (void)failedOnCallingAPI:(YRDURLResponse *)response withErrorType:(YRDAPIManagerErrorType)errorType
{
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    [self beforePerformFailWithResponse:response];
    //代理回调
    if ([self.delegate respondsToSelector:@selector(managerCallAPIDidFailed:)]) {
        [self.delegate managerCallAPIDidFailed:self];
    }
    //block回调
    !self.failureCompletionBlock?:self.failureCompletionBlock(self);
    
    [self afterPerformFailWithResponse:response];
    [self clearCompletionBlock];

}
#pragma mark - method for interceptor
/*
 拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
 当两种情况共存的时候，子类重载的方法一定要调用一下super
 然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
 
 notes:
 正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
 但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的
 所有重载的方法，都要调用一下super,这样才能保证外部interceptor能够被调到
 这就是decorate pattern
 */
- (void)beforePerformSuccessWithResponse:(YRDURLResponse *)response
{
    self.errorType = YRDAPIManagerErrorTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformSuccessWithResponse:)]) {
        [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
}

- (void)afterPerformSuccessWithResponse:(YRDURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (void)beforePerformFailWithResponse:(YRDURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
}

- (void)afterPerformFailWithResponse:(YRDURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

#pragma mark - method for child

- (void)cleanData
{
        IMP childIMP = [self.child methodForSelector:@selector(cleanData)];
        IMP selfIMP = [self methodForSelector:@selector(cleanData)];
        
        if (childIMP == selfIMP) {
            self.fetchedRawData = nil;
            self.errorMessage = nil;
            self.errorType = YRDAPIManagerErrorTypeDefault;
        } else {
            if ([self.child respondsToSelector:@selector(cleanData)]) {
                [self.child cleanData];
            }
        }
}
//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
- (NSDictionary *)reformParams:(NSDictionary *)params
{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

- (BOOL)shouldCache
{
    return kYRDShouldCache;
}

#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}
- (BOOL)hasCacheWithParams:(NSDictionary *)params
{
    NSString *serviceIdentifier = self.child.serviceType;
    NSString *methodName = self.child.methodName;
    NSData *result = [self.cache fetchCachedDataWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params];
    
    if (result == nil) {
        return NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        YRDURLResponse *response = [[YRDURLResponse alloc] initWithData:result];
        response.requestParams = params;
        [YRDLogger logDebugInfoWithCachedResponse:response methodName:methodName serviceIdentifier:[[YRDServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier]];
        [self successedOnCallingAPI:response];
    });
    return YES;
}
#pragma mark - getters and setters
- (YRDCache *)cache {
    if (!_cache) {
        _cache = [YRDCache sharedInstance];
    }
    return _cache;
}
- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}
- (BOOL)isReachable {
    BOOL isReachability = [YRDAppContext sharedInstance].isReachable;
    if (!isReachability) {
        self.errorType = YRDAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (BOOL)isLoading {
    return [self.requestIdList count] > 0;
}


@end
