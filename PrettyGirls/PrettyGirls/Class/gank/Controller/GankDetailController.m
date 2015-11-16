//
//  GankDetailController.m
//  PrettyGirls
//
//  Created by Tengfei on 15/11/15.
//  Copyright © 2015年 tengfei. All rights reserved.
//

#import "GankDetailController.h"
#import "MainModel.h"

@interface GankDetailController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GankDetailController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"干货-详情页面"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"干货-详情页面"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = self.model.desc;
    
    [HUDTools showLoading:@"加载中..."];
    self.webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:KUrl(self.model.url)];
    [self.webView loadRequest:request];
    if ([self.model.type isEqualToString:@"休息视频"]) {
        [self initNotice];//加载视频横屏的通知
    }
}


#pragma mark - 刷新 页面
-(void)refreshWebView
{
    [self.webView reload];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUDTools hideLoading];
    
    //自动播放
    NSString * requestDurationString = @"document.documentElement.getElementsByTagName(\"video\")[0].play()";
    [self.webView stringByEvaluatingJavaScriptFromString:requestDurationString];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [HUDTools hideLoading];
}

#pragma - mark 视频播放的相关，初始化通知
-(void)initNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
}


#pragma - mark  进入全屏
-(void)begainFullScreen
{
    [HUDTools hideLoading];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;
    
    //强制横屏：-：右偏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
#pragma - mark 退出全屏
-(void)endFullScreen
{
    NSLog(@"------endFullScreen");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;
    
    //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val =UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

-(void)dealloc
{
    [HUDTools hideLoading];
}

@end
