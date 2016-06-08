//
//  HTTPPostTableViewController.m
//  YRDGoodArc
//
//  Created by yurongde on 16/6/2.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "HTTPPostTableViewController.h"
#import "YiBaoGaoApiManager.h"
#import "SchoolListReformer.h"
#import "SchoolItem.h"

static NSString *const kCellID = @"cell";
@interface HTTPPostTableViewController ()<YRDAPIManagerApiCallBackDelegate>
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) YiBaoGaoApiManager *apiManager;
@property (nonatomic) YiBaoGaoApiManager *apiManager1;

@property (nonatomic) SchoolListReformer *reformer;
@end

@implementation HTTPPostTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellID];
    self.tableView.tableFooterView = [UIView new];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
   NSInteger requestID = [self.apiManager loadData];
    @weakify(self)
    [self.apiManager1 startWithCompletionBlockWithSuccess:^(YRDAPIBaseManager *manager) {
        @strongify(self)
        NSLog(@"blockChange1");
        NSArray *arr = [manager fetchDataWithReformer:self.reformer];
        [self.dataSource addObjectsFromArray:arr];

        [self.tableView reloadData];

    } failure:^(YRDAPIBaseManager *manager) {
        
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    NSLog(@"控制器内存释放");
    
}
#pragma mark - YRDAPIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(YRDAPIBaseManager *)manager {
    //数据成功返回
    if ([manager isMemberOfClass:[YiBaoGaoApiManager class]]) {
        NSLog(@"YibaoApi");
    }
    NSArray *arr = [manager fetchDataWithReformer:self.reformer];
    [self.dataSource addObjectsFromArray:arr];

    [self.tableView reloadData];
    
}
- (void)managerCallAPIDidFailed:(YRDAPIBaseManager *)manager {
    //数据返回不正确
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
    }
    SchoolItem *item = self.dataSource[indexPath.row];
    cell.textLabel.text = item.xxmc;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -getters and setters
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
- (YiBaoGaoApiManager *)apiManager {
    if (!_apiManager) {
        _apiManager = [[YiBaoGaoApiManager alloc]init];
        _apiManager.delegate = self;
    }
    return _apiManager;
}
- (YiBaoGaoApiManager *)apiManager1 {
    if (!_apiManager1) {
        _apiManager1 = [[YiBaoGaoApiManager alloc]init];
//        _apiManager1.delegate = self;
    }
    return _apiManager1;
}
- (SchoolListReformer *)reformer {
    if (!_reformer) {
        _reformer = [[SchoolListReformer alloc]init];
    }
    return _reformer;
}
@end
