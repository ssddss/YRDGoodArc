//
//  YRDLocationManager.h
//  yili
//
//  Created by casa on 15/10/12.
//  Copyright © 2015年 Beauty Sight Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, YRDLocationManagerLocationServiceStatus) {
    YRDLocationManagerLocationServiceStatusDefault,               //默认状态
    YRDLocationManagerLocationServiceStatusOK,                    //定位功能正常
    YRDLocationManagerLocationServiceStatusUnknownError,          //未知错误
    YRDLocationManagerLocationServiceStatusUnAvailable,           //定位功能关掉了
    YRDLocationManagerLocationServiceStatusNoAuthorization,       //定位功能打开，但是用户不允许使用定位
    YRDLocationManagerLocationServiceStatusNoNetwork,             //没有网络
    YRDLocationManagerLocationServiceStatusNotDetermined          //用户还没做出是否要允许应用使用定位功能的决定，第一次安装应用的时候会提示用户做出是否允许使用定位功能的决定
};

typedef NS_ENUM(NSUInteger, YRDLocationManagerLocationResult) {
    YRDLocationManagerLocationResultDefault,              //默认状态
    YRDLocationManagerLocationResultLocating,             //定位中
    YRDLocationManagerLocationResultSuccess,              //定位成功
    YRDLocationManagerLocationResultFail,                 //定位失败
    YRDLocationManagerLocationResultParamsError,          //调用API的参数错了
    YRDLocationManagerLocationResultTimeout,              //超时
    YRDLocationManagerLocationResultNoNetwork,            //没有网络
    YRDLocationManagerLocationResultNoContent             //API没返回数据或返回数据是错的
};

@interface YRDLocationManager : NSObject

@property (nonatomic, assign, readonly) YRDLocationManagerLocationResult locationResult;
@property (nonatomic, assign,readonly) YRDLocationManagerLocationServiceStatus locationStatus;
@property (nonatomic, copy, readonly) CLLocation *currentLocation;

+ (instancetype)sharedInstance;

- (void)startLocation;
- (void)stopLocation;
- (void)restartLocation;

@end
