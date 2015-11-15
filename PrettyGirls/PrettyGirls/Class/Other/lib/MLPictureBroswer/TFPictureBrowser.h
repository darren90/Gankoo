//
//  MLPictureBrowser.h
//  InventoryTool
//
//  Created by molon on 14-2-19.
//  Copyright (c) 2014年 Molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFPictureBrowser;
@class MLPictureBrowserCell;
@class MLBroadcastView;
@protocol MLPictureBrowserDelegate <NSObject>

@optional
//滚动到某一个页面
- (void)didScrollToIndex:(NSUInteger)index ofMLPictureBrowser:(TFPictureBrowser*)pictureBrowser;
- (void)didDisappearOfMLPictureBrowser:(TFPictureBrowser*)pictureBrowser;

@optional
//下面这俩自定义覆盖View是替换了页号的那个默认覆盖View，需要自行添加一些页号显示等其他元素
//自定义覆盖View,这俩是绑定的，只有俩都设置了才有效
- (UIView*)customOverlayViewOfMLPictureBrowser:(TFPictureBrowser*)pictureBrowser;
//自定义覆盖View的frame
- (CGRect)customOverlayViewFrameOfMLPictureBrowser:(TFPictureBrowser*)pictureBrowser;

@optional
//自定义Cell的覆盖View
- (UIView*)customOverlayViewOfMLPictureCell:(MLPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;
//自定义Cell覆盖View的frame
- (CGRect)customOverlayViewFrameOfMLPictureCell:(MLPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;

-(void)PictureBrowserCommentButtonClick:(UIButton *)button;

@end

@interface TFPictureBrowser : UIViewController

@property(nonatomic,readonly,getter=mainView) MLBroadcastView *broadcastView;

@property(nonatomic,weak) id<MLPictureBrowserDelegate> delegate;
@property(nonatomic,strong) NSArray *pictures;//要展示的图片列表,元素为MLPicture
@property(nonatomic,assign,readonly) NSUInteger currentIndex; //当前展示的索引位置

//通常情况下使用，通过URL数组和要显示的下标
- (void)showWithPictureURLs:(NSArray*)pictureURLs atIndex:(NSUInteger)index;
- (void)showWithPictureURLs:(NSArray*)pictureURLs withTextArray:(NSArray*)textArray atIndex:(NSUInteger)index;
- (void)showWithPictureURLs:(NSArray*)pictureURLs withTextArray:(NSArray*)textArray WithcommentNum:(NSString *)commentNum atIndex:(NSUInteger)index;


//滚动到某一个页面
- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated;

@end
