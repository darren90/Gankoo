//
//  GirlsController.m
//  PrettyGirls
//
//  Created by Tengfei on 15/11/15.
//  Copyright © 2015年 tengfei. All rights reserved.
//

#import "GirlsController.h"
#import "WaterCell.h"
#import "MainModel.h"

@interface GirlsController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,weak)UICollectionView *waterView;

@property (nonatomic,assign)int page;

@property (nonatomic,assign)BOOL isRefreshing;

@end

@implementation GirlsController

static NSString *const IDENTTFIER = @"waterFlow";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initCacheData];
  
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollToTop)];
    [self.navigationController.navigationBar addGestureRecognizer:tap];
    
    CGRect rect = CGRectMake(0, 0, KViewW, KViewH);//减去顶部NavBar64，底部TabBar49
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView * waterView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:flowLayout];
    [waterView registerNib:[UINib nibWithNibName:@"WaterCell" bundle:nil] forCellWithReuseIdentifier:IDENTTFIER];
    [self.view addSubview:waterView];
    
    waterView.backgroundColor = [UIColor whiteColor];
    waterView.delegate = self;
    waterView.dataSource = self;
    self.waterView = waterView;
    
    float ratio = 1.2;
    int imgW = (ScreenW - 2*(10+7)) / 3;
    int imgH = ratio * imgW + 26;
    
    flowLayout.itemSize = CGSizeMake(imgW, imgH);
    flowLayout.minimumLineSpacing = 10;// =70/3
    flowLayout.minimumInteritemSpacing = 7;
    //flowLayout.headerReferenceSize = CGSizeMake(10, 10);
    flowLayout.sectionInset = UIEdgeInsetsMake(40/3, 10, 0, 10);
    
    self.page = 1;
    self.isRefreshing = YES;
    //第一次请求
    [self requestData];
    
    __weak __typeof(self) weakSelf = self;
    //1：头部刷新
    self.waterView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1 ;
        weakSelf.isRefreshing = YES;
        [weakSelf requestData];
    }];
    
    //2：尾部刷新
    self.waterView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self.page ++;
        weakSelf.isRefreshing = NO;
        [weakSelf requestData];
    }];
}

-(void)initCacheData
{
    NSArray *array = [DatabaseTool getPrettyGirls];
    if (array.count) {
        [self.dataArray addObjectsFromArray:array];
        [self.waterView reloadData];
    }
}

- (void)scrollToTop
{
//    [self.specialTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self.waterView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (void)requestData
{
    __weak __typeof (self)weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@/%@/%d",[NSString getUrlWithPort:KInter_Girls],KRowPage,self.page];
    
    [AFNTool getWithURL:url params:nil success:^(id json) {
        [weakSelf stopFresh];
        NSArray *array = [MainModel mj_objectArrayWithKeyValuesArray:json[@"results"]];
        if (weakSelf.isRefreshing) {
            [self.dataArray removeAllObjects];
        }
        [weakSelf.dataArray addObjectsFromArray:array];
        [weakSelf.waterView reloadData];
        [DatabaseTool addPrettyGirlsWithArray:array];
    } failure:^(NSError *error) {
        [weakSelf stopFresh];
    }];
}


- (void)stopFresh
{
    [self.waterView.mj_footer endRefreshing];
    [self.waterView.mj_header endRefreshing];
}

- (void)getSuccessData:(id)json
{
 
}

#pragma  - mark 视频搜索界面
- (void)rightBtnClick
{
    [self performSegueWithIdentifier:@"movieSearch" sender:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WaterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTTFIER forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TFPictureBrowser *browser = [[TFPictureBrowser alloc]init];
    NSMutableArray *pics = [NSMutableArray array];
    for (MainModel *model in self.dataArray) {
        [pics addObject:model.url];
    }
    [browser showWithPictureURLs:pics atIndex:indexPath.item];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
