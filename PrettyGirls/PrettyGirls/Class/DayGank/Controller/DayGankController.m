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


-(NSString *)getDateStr{
    NSInteger year,month,day,hour,min,sec,week;
    NSString *weekStr=nil;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now = [NSDate date];;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:now];
    year = [comps year];
    week = [comps weekday];
    month = [comps month];
    day = [comps day];
    hour = [comps hour];
    min = [comps minute];
    sec = [comps second];
    
//    if(week==1) {//星期天
//    }else if(week==2){
//    }else if(week==3){
//    }else if(week==4){
//    }else if(week==5){
//    }else if(week==6){
//        day = day - 1;
//        week = week -1;
//    }else if(week==7){//星期六
//        day = day - 2;
//        week = week - 2;
//    }else {
//        NSLog(@"error!");
//    }
    day = [self getGankDate:day week:week];
    if (hour < 18) {
        day = [self getGankDate:day-1 week:week-1];
    }
    
    NSLog(@"现在是:%ld年%ld月%ld日 %ld时%ld分%ld秒  %@",(long)year,(long)month,(long)day,(long)hour,(long)min,(long)sec,weekStr);
    NSLog(@"现在是:%ld/%ld/%ld",(long)year,(long)month,(long)day);
    return[NSString stringWithFormat:@"%ld/%ld/%ld",(long)year,(long)month,(long)day];
}

-(NSInteger)getGankDate:(NSInteger)day week:(NSInteger)week
{
    if(week==1) {
        day = day - 2;
    }else if(week==2){
    }else if(week==3){
    }else if(week==4){
    }else if(week==5){
    }else if(week==6){
    }else if(week==7){
        day = day - 1;
    }else {
        NSLog(@"error!");
    }
    return day;
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
