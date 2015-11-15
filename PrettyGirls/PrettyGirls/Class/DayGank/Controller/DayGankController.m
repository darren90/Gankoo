//
//  DayGankController.m
//  PrettyGirls
//
//  Created by Tengfei on 15/11/15.
//  Copyright © 2015年 tengfei. All rights reserved.
//

#import "DayGankController.h"
#import "TFCycleScrollView.h"
#import "MainModel.h"
#import "TFPictureBrowser.h"
#import "GankCell.h"
#import "GankDetailController.h"
#import "DayModel.h"

@interface DayGankController ()<CycleScrollViewDelegate>

@property (nonatomic,weak) TFCycleScrollView *cycleView;
@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)NSMutableArray * imgsArray;

@property (nonatomic,assign)BOOL isRefreshing;
@end

@implementation DayGankController

- (void)viewDidLoad {
    [super viewDidLoad];
    TFCycleScrollView *cycleView = [[TFCycleScrollView alloc]init];
    cycleView.frame = CGRectMake(0,0, self.view.frame.size.width, 200);
    self.cycleView = cycleView;

    cycleView.delegate = self;
    self.tableView.tableHeaderView = cycleView;

    NSArray *imagesURLStrings = @[@"http://p2.so.qhimg.com/t013314dfd21f1c9bf7.jpg"];
    cycleView.placeholderImage = @"nopic_780x420";
    cycleView.imgsArray = imagesURLStrings;

    self.tableView.rowHeight = 80;
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollToTop)];
    [self.navigationController.navigationBar addGestureRecognizer:tap];
    
    //第一次请求
    [self requestData];
    
    __weak __typeof(self) weakSelf = self;
    //1：头部刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isRefreshing = YES;
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
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",KURLPrefix,KInter_day,@"2015/08/07"];
    
    [AFNTool getWithURL:url params:nil success:^(id json) {
        [weakSelf stopFresh];
        [weakSelf successTidyData:json[@"results"]];
    } failure:^(NSError *error) {
        [weakSelf stopFresh];
    }];
    
}

-(void)successTidyData:(NSDictionary *)json
{
    //通过KEY找到value
    NSArray *imgDicArray = [MainModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"福利"]] ;
    if (imgDicArray.count) {
        for (MainModel *model in imgDicArray) {
            [self.imgsArray addObject:model.url];
            self.cycleView.imgsArray = self.imgsArray;
        }
    }
    
    for (NSString *key in json) {
        NSLog(@"key: %@ value: %@", key, json[key]);
        if ([key isEqualToString:@"福利"]) continue;
        DayModel *dayModel = [[DayModel alloc]init];
        dayModel.title = key;
        dayModel.dataList = [MainModel mj_objectArrayWithKeyValuesArray:json[key]];
        [self.dataArray addObject:dayModel];
    }
    
    [self.tableView reloadData];
}

- (void)stopFresh
{
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}


#pragma  - mark

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DayModel *model = self.dataArray[section];
    return model.dataList.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    DayModel *model = self.dataArray[section];
    return model.title;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = KColor(193, 193, 193);
    DayModel *model = self.dataArray[section];
    titleLabel.text = [NSString stringWithFormat:@"   %@",model.title];
    titleLabel.textColor = [UIColor blackColor];
    return titleLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GankCell"];
    if(cell == nil){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GankCell" owner:nil options:nil]lastObject];
    }
    DayModel *day = self.dataArray[indexPath.section];
    cell.model = day.dataList[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    DayModel *day = self.dataArray[indexPath.section];
    MainModel *model = day.dataList[indexPath.row];
    if ([model.type isEqualToString:@"福利"]) {
        TFPictureBrowser *browser = [[TFPictureBrowser alloc]init];
        NSMutableArray *pics = [NSMutableArray array];
        for (MainModel *model in self.dataArray) {
            [pics addObject:model.url];
        }
        [browser showWithPictureURLs:pics atIndex:indexPath.row];

    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GankDetailController *detailVc = [sb instantiateViewControllerWithIdentifier:@"GankDetail"];
        detailVc.model = model;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

#pragma mark - TFCycleScrollView代理
-(void)cycleScrollViewDidSelectAtIndex:(NSInteger)index
{
    TFPictureBrowser *browser = [[TFPictureBrowser alloc]init];
    [browser showWithPictureURLs:self.imgsArray atIndex:index];
}


- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


-(NSMutableArray *)imgsArray
{
    if (!_imgsArray) {
        _imgsArray = [NSMutableArray array];
    }
    return _imgsArray;
}


@end
