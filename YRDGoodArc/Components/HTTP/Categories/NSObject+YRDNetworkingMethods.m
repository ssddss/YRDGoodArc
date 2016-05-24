//
//  NSObject+YRDNetworkingMethods.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/20.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "NSObject+YRDNetworkingMethods.h"

@implementation NSObject (YRDNetworkingMethods)

- (id)YRD_defaultValue:(id)defaultData
{
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    
    if ([self YRD_isEmptyObject]) {
        return defaultData;
    }
    
    return self;
}

- (BOOL)YRD_isEmptyObject
{
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}
@end
