//
//  WeatherViewController.m
//  YRDGoodArc
//
//  Created by yurongde on 16/5/24.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherApiManager.h"

@interface WeatherViewController ()
@property (nonatomic) WeatherApiManager *apiManager;
@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.apiManager loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (WeatherApiManager *)apiManager {
    if (!_apiManager) {
        _apiManager = [[WeatherApiManager alloc]init];
    }
    return _apiManager;
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
