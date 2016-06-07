//
//  User.m
//  YRDGoodArc
//
//  Created by yurongde on 16/3/14.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "User.h"

@interface User()<NSCoding,NSCopying>
@end
@implementation User
/**
 *  如果字典的Key与Model的key不一致
 *
 *  @return
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"name1",
             @"age" : @"age1",
             @"info" : @"info1"
             };
}
//校验
/**
 *  json转换为Model时调用
 *
 *  @param dic <#dic description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
//    NSNumber *timestamp = dic[@"age1"];
//    if (![timestamp isKindOfClass:[NSNumber class]])
//        return NO;
    return YES;
}
// 当 Model 转为 JSON 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if (!_name) {
        return NO;
    }
    return YES;
}
// 直接添加以下代码即可自动完成
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}
- (NSUInteger)hash {
    return [self yy_modelHash];
}
- (BOOL)isEqual:(id)object{
    return [self yy_modelIsEqual:object];
}
- (NSString *)description {
    return [self yy_modelDescription];
}
@end
