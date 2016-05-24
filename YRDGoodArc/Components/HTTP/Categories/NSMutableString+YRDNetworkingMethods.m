//
//  NSMutableString+YRDNetworkingMethods.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/20.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "NSMutableString+YRDNetworkingMethods.h"
#import "NSObject+YRDNetworkingMethods.h"
@implementation NSMutableString (YRDNetworkingMethods)
- (void)appendURLRequest:(NSURLRequest *)request
{
    [self appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [self appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [self appendFormat:@"\n\nHTTP Body:\n\t%@", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] YRD_defaultValue:@"\t\t\t\tN/A"]];
}
@end
