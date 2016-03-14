//
//  User.h
//  YRDGoodArc
//
//  Created by yurongde on 16/3/14.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dog.h"
@interface User : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *age;
@property (nonatomic, copy) NSDictionary *info;
@property (nonatomic) Dog *dog;
@end
