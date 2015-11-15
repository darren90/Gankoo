//
//  GirlsController.m
//  PrettyGirls
//
//  Created by Tengfei on 15/11/15.
//  Copyright © 2015年 tengfei. All rights reserved.
//

#import "GirlsController.h"
#import "WaterCell.h"
#import "WaterModel.h"

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
    
  
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollToTop)];
    [self.navigationController.navigationBar addGestureRecognizer:tap];
    
    CGRect rect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49);//减去顶部NavBar64，底部TabBar49
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView * waterView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:flowLayout];
    [waterView registerNib:[UINib nibWithNibName:@"WaterCell" bundle:nil] forCellWithReuseIdentifier:IDENTTFIER];
    [self.view addSubview:waterView];
    
    waterView.backgroundColor = [UIColor whiteColor];
    waterView.delegate = self;
    waterView.dataSource = self;
    self.waterView = waterView;
    
    float ratio = 1.3 ;//宽高比 420.0
    int imgW = (ScreenW - 2*(10+7)) / 3;
    int imgH = ratio * imgW + 47;
    
    flowLayout.itemSize = CGSizeMake(imgW, imgH);
    flowLayout.minimumLineSpacing = 10;// =70/3
    flowLayout.minimumInteritemSpacing = 7;
    //flowLayout.headerReferenceSize = CGSizeMake(10, 10);
    flowLayout.sectionInset = UIEdgeInsetsMake(40/3, 10, 0, 10);
    
    self.page = 1;
    
   
    //第一次请求
    [self requestData];
    
    __weak __typeof(self) weakSelf = self;
    //1：头部刷新
    self.waterView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.page = 1 ;
        weakSelf.isRefreshing = YES;
        [weakSelf requestData];
    }];
    
    //2：尾部刷新
    self.waterView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self.page ++;
        [weakSelf requestData];
    }];
}

- (void)scrollToTop
{
//    [self.specialTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
   
    [self.waterView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (void)requestData
{
    __weak __typeof (self)weakSelf = self;
    //[NSString getHttpUrlWithPort:KInter_Home]
    //http://gank.avosapps.com/api/data/%E7%A6%8F%E5%88%A9/10/1
    [AFNTool getWithURL:@"http://gank.avosapps.com/api/data/%E7%A6%8F%E5%88%A9/10/1" params:nil success:^(id json) {
        NSArray *array = [WaterModel mj_objectArrayWithKeyValuesArray:json[@"results"]];
        [self.dataArray addObjectsFromArray:array];
        [self.waterView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)stopFresh
{
    [self.waterView.footer endRefreshing];
    [self.waterView.header endRefreshing];
    //self.waterView.header.hidden = YES;
    self.waterView.footer.hidden = YES;
 
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
