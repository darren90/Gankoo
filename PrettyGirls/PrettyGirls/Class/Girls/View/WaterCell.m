//
//  WaterCell.m
//  PrettyGirls
//
//  Created by Tengfei on 15/11/15.
//  Copyright © 2015年 tengfei. All rights reserved.
//

#import "WaterCell.h"
#import "MainModel.h"

@interface WaterCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation WaterCell
- (void)awakeFromNib {
    // Initialization code
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds = YES;
}

-(void)setModel:(MainModel *)model
{
    _model = model;
    
    [self.iconView sd_setImageWithURL:KUrl(model.url) placeholderImage:PlaceholderImg];
}


- (void)drawRect:(CGRect)rect
{
    CGFloat lineHeight = 0.4;
    CGFloat cellHetht = self.frame.size.height;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 0, cellHetht - lineHeight);
    CGContextAddLineToPoint(ctx, self.contentView.frame.size.width, cellHetht - lineHeight);
    CGContextSetRGBStrokeColor(ctx, 0.88, 0.88, 0.88, 1.0);
    CGContextStrokePath(ctx);
}

@end
