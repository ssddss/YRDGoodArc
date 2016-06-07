//
//  YRDServiceFactory.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/23.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "YRDServiceFactory.h"
#import "YRDNetworkingConfiguration.h"
#import "YRDServiceYiBaoGao.h"
#import "WeatherService.h"
#import "YRDServiceChangable.h"

NSString * const kYRDServiceYibaogao = @"YiBaoGao";
NSString *const kYRDServiceWeather = @"weather";
NSString *const kYRDServiceChangable = @"ChangableServiceUrl";
@interface YRDServiceFactory()
    
@property (nonatomic, strong) NSCache *serviceStorage;

@end
@implementation YRDServiceFactory
#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static YRDServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YRDServiceFactory alloc] init];
    });
    return sharedInstance;
}
#pragma mark - public methods
- (YRDService<YRDServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier
{
    if ([self.serviceStorage objectForKey:identifier] == nil) {
        [self.serviceStorage setObject:[self newServiceWithIdentifier:identifier]
                                forKey:identifier];
    }
    return [self.serviceStorage objectForKey:identifier];
}

#pragma mark - private methods
- (YRDService<YRDServiceProtocal> *)newServiceWithIdentifier:(NSString *)identifier
{
    // YiBaoGao
    if ([identifier isEqualToString:kYRDServiceYibaogao]) {
        return [[YRDServiceYiBaoGao alloc] init];
    }
  
    else if ([identifier isEqualToString:kYRDServiceWeather]) {
        return [[WeatherService alloc]init];
    }
    else if ([identifier isEqualToString:kYRDServiceChangable]) {
        return [[YRDServiceChangable alloc]init];
    }
    return nil;
}

#pragma mark - getters and setters
- (NSCache *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSCache alloc] init];
        _serviceStorage.countLimit = 5; // 我在这里随意定了一个，具体的值还是要取决于各自App的要求。
    }
    return _serviceStorage;
}
@end
