//
//  NSString+YRDNetworkingMethods.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/20.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "NSString+YRDNetworkingMethods.h"
#include <CommonCrypto/CommonDigest.h>

@implementation NSString (YRDNetworkingMethods)
- (NSString *)YRD_md5 {
    NSData *inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
    
    NSMutableString *hashStr = [NSMutableString string];
    int i = 0;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [hashStr appendFormat:@"%02x", outputData[i]];
    }
    return hashStr;

}
@end
