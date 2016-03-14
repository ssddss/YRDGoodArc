//
//  Dog.h
//  YRDGoodArc
//
//  Created by yurongde on 16/3/14.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dog : NSObject<NSCoding>
@property (nonatomic, copy)NSString *dogName;
@property (nonatomic, copy) NSNumber *dogAge;
@end
