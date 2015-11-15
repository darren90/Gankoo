//
//  WaterCell.m
//  PrettyGirls
//
//  Created by Tengfei on 15/11/15.
//  Copyright © 2015年 tengfei. All rights reserved.
//

#import "WaterCell.h"
#import "WaterModel.h"

@interface WaterCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation WaterCell
- (void)awakeFromNib {
    // Initialization code
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds = YES;
}

-(void)setModel:(WaterModel *)model
{
    _model = model;
    
    [self.iconView sd_setImageWithURL:KUrl(model.url) placeholderImage:PlaceholderImg];
}

@end
