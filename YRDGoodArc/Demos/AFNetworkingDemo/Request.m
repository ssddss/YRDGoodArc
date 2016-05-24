//
//  Request.m
//  YRDGoodArc
//
//  Created by yurongde on 16/3/14.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "Request.h"
#import "AFAppDotNetAPIClient.h"

@implementation Request
+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    return [[AFAppDotNetAPIClient sharedClient] GET:@"?hi=123" parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSLog(@"%@",JSON);
        
        if (block) {
//            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
@end
