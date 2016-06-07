//
//  YRDService.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/23.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "YRDService.h"

@implementation YRDService
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if ([self conformsToProtocol:@protocol(YRDServiceProtocal)]) {
        self.child = (id<YRDServiceProtocal>)self;
    }
    else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    return self;
}

#pragma mark - getters and setters
- (NSString *)privateKey
{
    return self.child.isOnline ? self.child.onlinePrivateKey : self.child.offlinePrivateKey;
}

- (NSString *)publicKey
{
    return self.child.isOnline ? self.child.onlinePublicKey : self.child.offlinePublicKey;
}

- (NSString *)apiBaseUrl
{
    return self.child.isOnline ? self.child.onlineApiBaseUrl : self.child.offlineApiBaseUrl;
}

- (NSString *)apiVersion
{
    return self.child.isOnline ? self.child.onlineApiVersion : self.child.offlineApiVersion;
}
@end
