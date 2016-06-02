//
//  WeatherApiManager.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/24.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "YiBaoGaoApiManager.h"

@implementation YiBaoGaoApiManager

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    
    self.paramSource = self;
    self.validator = self;
    
    return self;
}


#pragma mark - Params
- (NSDictionary *)paramsForApi:(YRDAPIBaseManager *)manager {
    return nil;
}
#pragma mark - interceptor
- (void)afterCallingAPIWithParams:(NSDictionary *)params {
    [super afterCallingAPIWithParams:params];
    NSLog(@"requestId : %@",params[kYRDAPIBaseManagerRequestID]);
    
}
- (void)afterPerformSuccessWithResponse:(YRDURLResponse *)response {
    [super afterPerformSuccessWithResponse:response];
    NSLog(@"%@",response.content);
}
#pragma mark - YRDApiValidator
- (BOOL)manager:(YRDAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    if (manager.isLoading) {
        //可以有效地防止连续请求
        NSLog(@"前一个请求还未发送完");
        return NO;
    }
    return YES;
}
- (BOOL)manager:(YRDAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    NSLog(@"response : %@",data);
    return YES;
}
#pragma mark - APIManager
- (NSString *)methodName {
    return @"mobileapi/service/common/schools";
}
- (NSString *)serviceType {
    return kYRDServiceYibaogao;
}
- (YRDAPIManagerRequestType)requestType {
    return YRDAPIManagerRequestTypePost;
}
@end
