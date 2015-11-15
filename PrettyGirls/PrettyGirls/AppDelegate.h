//
//  AppDelegate.h
//  PrettyGirls
//
//  Created by Tengfei on 15/11/15.
//  Copyright © 2015年 tengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/***  是否允许横屏的标记 Yes:允许，NO:不允许 */
@property (nonatomic,assign)BOOL allowRotation;

@end

