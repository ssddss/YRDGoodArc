//
//  YRDServiceChangable.m
//  YRDGoodArc
//
//  Created by yurongde on 16/6/7.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "YRDServiceChangable.h"

@implementation YRDServiceChangable
- (BOOL)isOnline {
    return YES;
}

- (NSString *)onlineApiBaseUrl {
    return USER_DEFAULTS_GET(kYRDServiceChangable);
}


- (NSString *)onlineApiVersion
{
    return @"";
}

- (NSString *)onlinePrivateKey
{
    return @"";
}

- (NSString *)onlinePublicKey
{
    return @"";
}

- (NSString *)offlineApiBaseUrl
{
    return self.onlineApiBaseUrl;
}

- (NSString *)offlineApiVersion
{
    return self.onlineApiVersion;
}

- (NSString *)offlinePrivateKey
{
    return self.onlinePrivateKey;
}

- (NSString *)offlinePublicKey
{
    return self.onlinePublicKey;
}

@end
