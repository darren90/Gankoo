//
//  SettingViewController.m
//  PrettyGirls
//
//  Created by Tengfei on 15/11/17.
//  Copyright © 2015年 tengfei. All rights reserved.
//

#import "SettingViewController.h"
#import "WdCleanCaches.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *wifiSwitch;
@property (weak, nonatomic) IBOutlet UILabel *CacheLabel;
@property (weak, nonatomic) IBOutlet UILabel *VersionLabel;


@property (nonatomic,assign)float cacheSize;
@end

@implementation SettingViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"设置"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"设置"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1:version
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.VersionLabel.text = [NSString stringWithFormat:@"V:%@",version];
    
    //2:cacheSize
    NSString * path = [WdCleanCaches CachesDirectory];
    double cacheSize = [WdCleanCaches sizeWithFilePaht:path];
    self.cacheSize = cacheSize;
    self.CacheLabel.text = [NSString stringWithFormat:@"%.1fMB",cacheSize];
    
    //3:开关
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.wifiSwitch.on = [defaults boolForKey:KSettingUse3G];
}
- (IBAction)ChangeWifi:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.isOn forKey:KSettingUse3G];
    [defaults synchronize];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {//清理缓存
        NSString * path = [WdCleanCaches CachesDirectory];
        [HUDTools showSuccess:[NSString stringWithFormat:@"清理了%.1fMB的缓存",self.cacheSize]];
        [WdCleanCaches clearCachesWithFilePath:path];
        self.cacheSize = [WdCleanCaches sizeWithFilePaht:path];
        self.cacheSize = 0.0;//强制归0
    
        self.CacheLabel.text = [NSString stringWithFormat:@"%.1fMB",self.cacheSize];
        
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else if(indexPath.section == 2 && indexPath.row == 0){//APPStore评论
        NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",KAppid];
           
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else if(indexPath.section == 2 && indexPath.row == 1){//意见反馈
        NSString *stringURL = @"mailto:fengtenfei90@163.com";
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
