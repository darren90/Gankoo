//
//  GankCell.m
//  PrettyGirls
//
//  Created by Tengfei on 15/11/15.
//  Copyright © 2015年 tengfei. All rights reserved.
//

#import "GankCell.h"
#import "MainModel.h"

@interface GankCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *whoLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishLabel;

@end

@implementation GankCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)setModel:(MainModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.desc;
    self.whoLabel.text = model.who;
    self.publishLabel.text = model.publishedAt;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
