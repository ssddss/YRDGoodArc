//
//  NSDictionary+YRDNetworkingMethods.h
//  YRDGoodArc
//
//  Created by yurongde on 16/5/20.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YRDNetworkingMethods)
- (NSString *)YRD_urlParamsStringSignature:(BOOL)isForSignature;
- (NSString *)YRD_jsonString;
- (NSArray *)YRD_transformedUrlParamsArraySignature:(BOOL)isForSignature;
@end
