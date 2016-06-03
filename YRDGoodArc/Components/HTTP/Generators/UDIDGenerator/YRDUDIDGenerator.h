//
//  YRDUDIDGenerator.h
//  YRDGoodArc
//
//  Created by yurongde on 16/5/20.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRDUDIDGenerator : NSObject
+ (YRDUDIDGenerator *)sharedInstance;

- (NSString *)UDID;

- (void)saveUDID:(NSString *)udid;
@end
