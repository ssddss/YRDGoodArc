//
//  WeatherApiManager.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/24.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "WeatherApiManager.h"

@implementation WeatherApiManager

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.delegate = self;
    self.paramSource = self;
    self.validator = self;
    return self;
}

#pragma mark - YRDAPIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(YRDAPIBaseManager *)manager {
    //数据成功返回
}
- (void)managerCallAPIDidFailed:(YRDAPIBaseManager *)manager {
    //数据返回不正确
}
#pragma mark - Params
- (NSDictionary *)paramsForApi:(YRDAPIBaseManager *)manager {
    return @{@"cityname":@"广州",@"key":@"17c0a4b22ba32da3a9f68cb9b8a5159f"};
}
#pragma mark - YRDApiValidator
- (BOOL)manager:(YRDAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    return YES;
}
- (BOOL)manager:(YRDAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    NSLog(@"response : %@",data);
    return YES;
}
#pragma mark - APIManager
- (NSString *)methodName {
    return @"weather/index";
}
- (NSString *)serviceType {
    return kYRDServiceWeather;
}
- (YRDAPIManagerRequestType)requestType {
    return YRDAPIManagerRequestTypeGet;
}
@end
