//
//  SchoolListReformer.m
//  YRDGoodArc
//
//  Created by yurongde on 16/6/2.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "SchoolListReformer.h"
#import "YiBaoGaoApiManager.h"
#import "SchoolItem.h"

@implementation SchoolListReformer
- (id)manager:(YRDAPIBaseManager *)manager reformData:(NSDictionary *)data {
    if ([manager isKindOfClass:[YiBaoGaoApiManager class]]) {
        NSDictionary *dict = data[@"result"];
        return [NSArray yy_modelArrayWithClass:[SchoolItem class] json:dict];
    }
    return nil;
}
@end
