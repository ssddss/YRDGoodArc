//
//  YRDServiceFactory.h
//  YRDGoodArc
//
//  Created by yurongde on 16/5/23.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRDService.h"

@interface YRDServiceFactory : NSObject
+ (instancetype)sharedInstance;
- (YRDService<YRDServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier;
@end
