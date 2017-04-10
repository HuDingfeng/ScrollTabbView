//
//  BackgroundCollectionCell.m
//  Phoenix
//
//  Created by 胡定锋Mac on 16/8/8.
//  Copyright © 2016年 胡定锋Mac. All rights reserved.
//

#import "BackgroundCollectionCell.h"

@interface BackgroundCollectionCell()

@end
@implementation BackgroundCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)setShowsVc:(UIViewController *)showsVc{
    _showsVc = showsVc;
    [self addSubview:showsVc.view];
}

-(void)layoutSubviews{
    self.showsVc.view.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
}

@end
