//
//  NSURLRequest+YRDNetworkingMethods.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/20.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "NSURLRequest+YRDNetworkingMethods.h"
#import <objc/runtime.h>

static void *YRDNetworkingRequestParams;
@implementation NSURLRequest (YRDNetworkingMethods)
- (void)setRequestParams:(NSDictionary *)requestParams {
    objc_setAssociatedObject(self, &YRDNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);

}
- (NSDictionary *)requestParams
{
    return objc_getAssociatedObject(self, &YRDNetworkingRequestParams);
}
@end
