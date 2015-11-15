//
//  GankMainController.m
//  PrettyGirls
//
//  Created by Tengfei on 15/11/15.
//  Copyright © 2015年 tengfei. All rights reserved.
//

#import "GankMainController.h"
#import "GankController.h"
#import "TFLabel.h"

@interface GankMainController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollview;
@property(nonatomic,strong) TFLabel *oldTitleLable;
@property (nonatomic,assign) CGFloat beginOffsetX;


@property (nonatomic,strong)NSMutableArray * mainArray;
@end

@implementation GankMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollview.delegate = self;
    
    [self addController];
    [self addLable];
    
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.mainScrollview.contentSize = CGSizeMake(contentX, 0);
    self.mainScrollview.pagingEnabled = YES;
    
    // 添加默认控制器
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.mainScrollview.bounds;
    [self.mainScrollview addSubview:vc.view];
    TFLabel *lable = [self.topScrollView.subviews firstObject];
    lable.scale = 1.0;
    self.mainScrollview.showsHorizontalScrollIndicator = NO;
}

#pragma mark - ******************** 添加方法
#pragma mark - ******************** 添加 子控制器
/** 添加子控制器 */
- (void)addController
{
    for (int i=0 ; i< self.mainArray.count ;i++){
        GankController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Gank"];
        vc1.title = self.mainArray[i];
        vc1.urlDomain = self.mainArray[i];
        [self addChildViewController:vc1];
    }
}
#pragma mark - ******************** 添加标题栏
/** 添加标题栏 */
- (void)addLable
{
    for (int i = 0; i < self.mainArray.count; i++) {
        CGFloat lblW = 70;
        CGFloat lblH = 40;
        CGFloat lblY = 0;
        CGFloat lblX = i * lblW;
        TFLabel *lbl1 = [[TFLabel alloc]init];
        UIViewController *vc = self.childViewControllers[i];
        lbl1.text =vc.title;
        lbl1.frame = CGRectMake(lblX, lblY, lblW, lblH);
        lbl1.font = [UIFont fontWithName:@"HYQiHei" size:19];
        [self.topScrollView addSubview:lbl1];
        lbl1.tag = i;
        lbl1.userInteractionEnabled = YES;
        
        [lbl1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
    }
    self.topScrollView.contentSize = CGSizeMake(70 * 8, 0);
}

/** 标题栏label的点击事件 */
- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    TFLabel *titlelable = (TFLabel *)recognizer.view;
    
    CGFloat offsetX = titlelable.tag * self.mainScrollview.frame.size.width;
    
    CGFloat offsetY = self.mainScrollview.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.mainScrollview setContentOffset:offset animated:YES];
}

#pragma mark - ******************** scrollView代理方法

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.mainScrollview.frame.size.width;
    
    // 滚动标题栏
    TFLabel *titleLable = (TFLabel *)self.topScrollView.subviews[index];
    
    CGFloat offsetx = titleLable.center.x - self.topScrollView.frame.size.width * 0.5;
    
    CGFloat offsetMax = self.topScrollView.contentSize.width - self.topScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, self.topScrollView.contentOffset.y);
    [self.topScrollView setContentOffset:offset animated:YES];
    // 添加控制器
    GankController *newsVc = self.childViewControllers[index];
    newsVc.index = index;
    
    [self.topScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            TFLabel *temlabel = self.topScrollView.subviews[idx];
            temlabel.scale = 0.0;
        }
    }];
    
    if (newsVc.view.superview) return;
    
    newsVc.view.frame = scrollView.bounds;
    [self.mainScrollview addSubview:newsVc.view];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    TFLabel *labelLeft = self.topScrollView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.topScrollView.subviews.count) {
        TFLabel *labelRight = self.topScrollView.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
    
}


-(NSMutableArray *)mainArray
{
    if (_mainArray == nil) {
//  福利 | Android | iOS | 休息视频 | 拓展资源 | 前端 | all
        _mainArray = [NSMutableArray array];
        [_mainArray addObject:@"iOS"];
        [_mainArray addObject:@"Android"];
        [_mainArray addObject:@"前端"];
        [_mainArray addObject:@"拓展资源"];
        [_mainArray addObject:@"休息视频"];
        [_mainArray addObject:@"all"];
    }
    return _mainArray;
}

@end
