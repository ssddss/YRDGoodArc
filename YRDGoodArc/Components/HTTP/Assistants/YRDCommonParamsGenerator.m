//
//  YRDCommonParamsGenerator.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/23.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "YRDCommonParamsGenerator.h"
#import "YRDAppContext.h"

@implementation YRDCommonParamsGenerator
+ (NSDictionary *)commonParamsDictionary {
    YRDAppContext *context = [YRDAppContext sharedInstance];
    NSLog(@"device ip:%@",context.ip);
    return nil;
    //TODO
//    return @{
//             @"ostype2":context.ostype2,
//             @"udid2":context.udid2,
//             @"uuid2":context.uuid2,
//             @"app":context.appName,
//             @"cv":context.cv,
//             @"from":context.from,
//             @"m":context.m,
//             @"macid":context.macid,
//             @"o":context.o,
//             @"pm":context.pm,
//             @"qtime":context.qtime,
//             @"uuid":context.uuid,
//             @"i":context.i,
//             @"v":context.v
//             };
}
+ (NSDictionary *)commonParamsDictionaryForLog {
    YRDAppContext *context = [YRDAppContext sharedInstance];
    return nil;
//    return @{
//             @"guid":context.guid,
//             @"dvid":context.dvid,
//             @"net":context.net,
//             @"ver":context.ver,
//             @"ip":context.ip,
//             @"mac":context.mac,
//             @"geo":context.geo,
////             @"uid":context.uid,
//             @"chat_id":context.chatid,
//             @"p":context.p,
//             @"os":context.os,
//             @"v":context.v,
//             @"app":context.app,
//             @"ch":context.channelID,
//             @"ct":context.ct,
//             @"pmodel":context.pmodel
//             };

}
@end
