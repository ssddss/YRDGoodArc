//
//  YRDCachedObject.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/23.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "YRDCachedObject.h"
#import "YRDNetworkingConfiguration.h"
@interface YRDCachedObject()

@property (nonatomic, copy, readwrite) NSData *content;
@property (nonatomic, copy, readwrite) NSDate *lastUpdateTime;
@end
@implementation YRDCachedObject
#pragma mark - Life Cycle
- (instancetype)initWithContent:(NSData *)content {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.content = content;
    
    return self;
}
#pragma mark - Public methods
- (void)updateContent:(NSData *)content {
    self.content = content;
}

#pragma mark - getters and setters
- (BOOL)isEmpty {
    return self.content == nil;
}

- (BOOL)isOutdated {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
   
    return timeInterval > kYRDCacheOutdateTimeSeconds;
}
- (void)setContent:(NSData *)content {
    _content = [content copy];
     self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}
@end
