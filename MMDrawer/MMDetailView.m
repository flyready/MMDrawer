//
//  MMDetailView.m
//  MMDrawer
//
//  Created by 张明 on 17/3/21.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "MMDetailView.h"
#import "MMArticleModel.h"
#import <Masonry.h>
@interface MMDetailView ()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *contentLabel;
@end


@implementation MMDetailView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] init];
        self.contentLabel = [[UILabel alloc] init];
        [self addSubview:self.imageView];
        [self addSubview:self.contentLabel];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(20));
            make.top.equalTo(@(20));
            make.trailing.equalTo(@(20));
            make.height.equalTo(@(200));
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(20));
            make.top.equalTo(self.imageView.mas_bottom).offset(20);
            make.trailing.equalTo(@(20));
            make.height.equalTo(@(40));
            
        }];
    }
    return self;
}
- (void)configDetailViewWithArticleModel:(MMArticleModel *)mode
{
    self.imageView.image = mode.image;
    self.contentLabel.text = mode.content;
}



@end
