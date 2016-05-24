//
//  NSDictionary+YRDNetworkingMethods.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/20.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "NSDictionary+YRDNetworkingMethods.h"
#import "NSArray+YRDNetworkingMethods.h"

@implementation NSDictionary (YRDNetworkingMethods)

/** 字符串前面是没有问号的，如果用于POST，那就不用加问号，如果用于GET，就要加个问号 */
- (NSString *)YRD_urlParamsStringSignature:(BOOL)isForSignature {
    NSArray *sortedArray = [self YRD_transformedUrlParamsArraySignature:isForSignature];
    return [sortedArray YRD_paramsString];
}
/** 字典变json */
- (NSString *)YRD_jsonString {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (NSArray *)YRD_transformedUrlParamsArraySignature:(BOOL)isForSignature {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        if (!isForSignature) {
            obj = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)obj,  NULL,  (CFStringRef)@"!*'();:@&;=+$,/?%#[]",  kCFStringEncodingUTF8));
        }
        if ([obj length] > 0) {
            [result addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    NSArray *sortedResult = [result sortedArrayUsingSelector:@selector(compare:)];
    return sortedResult;

}
@end
