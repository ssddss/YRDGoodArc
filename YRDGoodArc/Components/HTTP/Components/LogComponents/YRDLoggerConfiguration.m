//
//  YRDLoggerConfiguration.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/23.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "YRDLoggerConfiguration.h"
#import "YRDAppContext.h"
@implementation YRDLoggerConfiguration
- (void)configWithAppType:(YRDAppType)appType {
    switch (appType) {
        case YRDAppTypeYibaogao: {
            self.channelID = [YRDAppContext sharedInstance].channelID;
            self.appKey = @"YBG";
            self.logAppName = [YRDAppContext sharedInstance].appName;
            self.serviceType = kYRDServiceYibaogao;
            self.sendLogMethod = @"admin.writeAppLog";
            self.sendActionMethod = @"admin.recordaction";
            self.sendLogKey = @"data";
            self.sendActionKey = @"action_note";
            break;

            
        }
    }
}
@end
