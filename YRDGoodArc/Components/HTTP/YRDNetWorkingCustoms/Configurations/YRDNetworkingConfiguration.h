//
//  YRDNetworkingConfiguration.h
//  YRDGoodArc
//
//  Created by yurongde on 16/5/20.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#ifndef YRDNetworkingConfiguration_h
#define YRDNetworkingConfiguration_h

typedef NS_ENUM(NSInteger, YRDAppType) {
    YRDAppTypeYibaogao,
   
};
typedef NS_ENUM(NSUInteger, YRDURLResponseStatus)
{
    YRDURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的YRDApiBaseManager来决定。
    YRDURLResponseStatusErrorTimeout,
    YRDURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};


static NSTimeInterval kYRDNetworkingTimeoutSeconds = 20.0f;

static NSString *YRDKeychainServiceName = @"com.yrdApps";
static NSString *YRDUDIDName = @"yrdAppsUDID";
static NSString *YRDPasteboardType = @"yrdAppsContent";

static BOOL kYRDShouldCache = NO;/**< 是否要缓存请求*/
static NSTimeInterval kYRDCacheOutdateTimeSeconds = 300; // 5分钟的cache过期时间
static NSUInteger kYRDCacheCountLimit = 1000; // 最多1000条cache

// Yigaobao
extern NSString * const kYRDServiceYibaogao;
//天气，测试用
extern NSString *const kYRDServiceWeather;

extern NSString *const kYRDServiceChangable;/**< 自定义保存的可变service,用于可以选择改变的服务器,使用NSUserDefault保存这个值*/


#endif /* YRDNetworkingConfiguration_h */
