//
//  YRDServiceYiBaoGao.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/23.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "YRDServiceYiBaoGao.h"

@implementation YRDServiceYiBaoGao
- (BOOL)isOnline {
    return YES;
}
- (NSString *)onlinePublicKey {
    return nil;
}
- (NSString *)offlinePublicKey {
    return nil;
}
- (NSString *)onlineApiBaseUrl {
    return @"http://v.juhe.cn";
}
- (NSString *)offlineApiBaseUrl {
    return nil;
}
- (NSString *)onlineApiVersion {
    return nil;
}
- (NSString *)offlineApiVersion {
    return nil;
}
- (NSString *)onlinePrivateKey {
    return nil;
}
- (NSString *)offlinePrivateKey {
    return nil;
}
@end
