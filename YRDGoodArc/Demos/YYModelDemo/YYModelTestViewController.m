//
//  YYModelTestViewController.m
//  YRDGoodArc
//
//  Created by yurongde on 16/3/14.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "YYModelTestViewController.h"
#import "User.h"
#import "NSObject+YYModel.h"
@interface YYModelTestViewController ()

@end

@implementation YYModelTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *originalData = @{@"name1":@"小明",@"age1":@"22",@"info1":@{@"cup":@"B"},@"dog":@{@"dogName":@"Amy",@"dogAge":@1}};
    
    User *user = [User yy_modelWithDictionary:originalData];
    
    NSLog(@"%@",user);
    
    User *userCopy = [user copy];
    
    if ([user isEqual:userCopy]) {
        NSLog(@"相等");
    }
    
    NSDictionary *transformData = [user yy_modelToJSONObject];
    
    NSLog(@"%@",transformData);
    
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user"];
    
    NSData *localData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    User *userLocal = [NSKeyedUnarchiver unarchiveObjectWithData:localData];
    
    NSLog(@"%@",userLocal);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
