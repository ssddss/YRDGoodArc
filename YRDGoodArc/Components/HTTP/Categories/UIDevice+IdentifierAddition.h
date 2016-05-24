//
//  UIDevice+IdentifierAddition.h
//  YRDGoodArc
//
//  Created by yurongde on 16/5/20.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (IdentifierAddition)
/*
 * @method uuid
 * @description apple identifier support iOS6 and iOS5 below
 */

- (NSString *) YRD_uuid;
- (NSString *) YRD_udid;
- (NSString *) YRD_macaddress;
- (NSString *) YRD_macaddressMD5;
- (NSString *) YRD_machineType;
- (NSString *) YRD_ostype;//显示“ios6，ios5”，只显示大版本号
- (NSString *) YRD_createUUID;
@end
