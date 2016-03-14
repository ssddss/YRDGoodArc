//
//  Dog.m
//  YRDGoodArc
//
//  Created by yurongde on 16/3/14.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "Dog.h"

@implementation Dog
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}
@end
