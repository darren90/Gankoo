//
//  GankController.m
//  PrettyGirls
//
//  Created by Tengfei on 15/11/15.
//  Copyright © 2015年 tengfei. All rights reserved.
//

#import "GankController.h"
#import "MainModel.h"
#import "TFPictureBrowser.h"
#import "GankCell.h"
#import "GankDetailController.h"

@interface GankController ()
@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,assign)int page;

@property (nonatomic,assign)BOOL isRefreshing;
@end

@implementation GankController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"干货-分类显示界面"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"干货-分类显示界面"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollToTop)];
    [self.navigationController.navigationBar addGestureRecognizer:tap];
    
    self.page = 1;
    //第一次请求
    [self requestData];
    
    __weak __typeof(self) weakSelf = self;
    //1：头部刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1 ;
        weakSelf.isRefreshing = YES;
        [weakSelf requestData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //2：尾部刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [weakSelf requestData];
    }];
}

- (void)scrollToTop
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}
- (void)requestData
{
    __weak __typeof (self)weakSelf = self;
   NSString *urlDo =[self.urlDomain stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%d",[NSString getUrlWithPort:urlDo],KRowPage,self.page];
    
    [AFNTool getWithURL:url params:nil success:^(id json) {
        [weakSelf stopFresh];
         NSArray *array = [MainModel mj_objectArrayWithKeyValuesArray:json[@"results"]];
        [weakSelf.dataArray addObjectsFromArray:array];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf stopFresh];
    }];
    
}

- (void)stopFresh
{
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}

- (void)getSuccessData:(id)json
{
    
}

#pragma  - mark

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GankCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GankCell" owner:nil options:nil]lastObject];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //GankDetail
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GankDetailController *detailVc = [sb instantiateViewControllerWithIdentifier:@"GankDetail"];
    detailVc.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:detailVc animated:YES];
}


- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
