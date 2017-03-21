//
//  MMTableViewCell.m
//  MMDrawer
//
//  Created by 张明 on 17/3/21.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "MMTableViewCell.h"
#import "MMArticleModel.h"
#import "MMDetailView.h"
#import <Masonry.h>
#define GCDeviceHeight self.superview.superview.bounds.size.height

#define GCUIColorFromRGB(rgbValue)                                                                \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                           \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                              \
blue:((float)(rgbValue & 0xFF)) / 255.0                                       \
alpha:1.0]

NSString *const MMTableViewCellIdentifier = @"MMTableViewCellIdentifier";
@interface MMTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIView *helperHideView;
@property (nonatomic, strong) MMDetailView *detailView;

@property (nonatomic, copy) MMCellSelectBlock selectBlock;
@property (nonatomic, copy) MMCellDeselectBlock deselectBlock;

@property (nonatomic, strong) MMArticleModel *model;

@property (nonatomic, assign) CGRect originCellFrame;
@property (nonatomic, assign) CGRect originHelperViewFrame;
@property (nonatomic, assign) CGRect originDetailViewFrame;


@end

@implementation MMTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp
{
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel = [[UILabel alloc] init];
    self.updateTimeLabel = [[UILabel alloc] init];
    self.infoLabel = [[UILabel alloc] init];
    self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.updateTimeLabel];
    [self addSubview:self.infoLabel];
    [self addSubview:self.detailButton];
    
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(20));
        make.trailing.equalTo(@(20));
        make.top.equalTo(@(20));
    }];
    [self.updateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(20));
        make.top.equalTo(@(20));
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    self.infoLabel.font = [UIFont systemFontOfSize:12];
    self.infoLabel.textColor = [UIColor grayColor];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel.mas_leading);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(250, 30));
    }];
    
    [self.detailButton setTitle:@"..." forState:UIControlStateNormal];
    [self.detailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.detailButton addTarget:self action:@selector(cellHandle) forControlEvents:UIControlEventTouchUpInside];
    self.detailButton.tag = 0;
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-20));
        make.top.equalTo(self.updateTimeLabel.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];

}

- (UIView *)helperHideView {
    if (!_helperHideView) {
        _helperHideView = [UIView new];
        _helperHideView.backgroundColor = [UIColor whiteColor];
        _helperHideView.alpha = 1.0;
    }
    return _helperHideView;
}

- (MMDetailView *)detailView {
    if (!_detailView) {
        _detailView = [MMDetailView new];
        _detailView.backgroundColor = GCUIColorFromRGB(0xFBFDFF);
    }
    return _detailView;
}

- (void)configCellWithArticleModel:(MMArticleModel *)articleModel
{
    self.model = articleModel;
    self.model = articleModel;
    self.titleLabel.text = articleModel.title;
    self.updateTimeLabel.text = articleModel.updateTime;
    self.infoLabel.text = [NSString stringWithFormat:@"发布 by %@ | %@ | %lu Comments",articleModel.author,articleModel.createTime,articleModel.commentsCount];
    [self.detailView configDetailViewWithArticleModel:articleModel];
}

- (void)cellHandle
{
    if (self.detailButton.tag) {
        [self deselectCell];
    }else
    {
        [self selectCell];
    }
}
- (void)selectCell {
    if (_selectBlock) {
        _selectBlock();
    }
}
- (void)deselectCell
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = self.originCellFrame;
        self.layer.shadowColor = [UIColor clearColor].CGColor;
        self.layer.shadowRadius = 0;
        self.layer.shadowOpacity = 0.0;
        
        self.detailView.layer.shadowColor = [UIColor clearColor].CGColor;
        self.detailView.layer.shadowRadius = 0;
        self.detailView.layer.shadowOpacity = 0.0;
        
        self.detailView.frame = self.originDetailViewFrame;
        self.helperHideView.frame = self.originHelperViewFrame;
        
        [self.detailButton setTitle:@"..." forState:UIControlStateNormal];
        
    } completion:^(BOOL finished) {
        [self.helperHideView removeFromSuperview];
        [self.detailView removeFromSuperview];
        if (_deselectBlock) {
            _deselectBlock();
        }
        self.detailButton.tag = 0;
    }];
}

- (void)selectToShowDetailWithContentOffsetY:(CGFloat)offsetY
{
    
    UIView *superview = self.superview;
    CGFloat height = CGRectGetMinY(self.frame) - offsetY + 30;
    NSLog(@"%f---%f",offsetY,height);
    [self.helperHideView setFrame:CGRectMake(0, offsetY, CGRectGetWidth(self.frame), height)];
    [superview insertSubview:self.helperHideView belowSubview:self];
    
    [self.detailView setFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - (GCDeviceHeight - 100 - 30*2), CGRectGetWidth(self.frame), GCDeviceHeight - 100 - 30 *2)];
    [superview insertSubview:self.detailView belowSubview:self.helperHideView];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.frame;
        self.originCellFrame = rect;
        CGPoint origin = CGPointMake(0, offsetY + 30);
        rect.origin = origin;
        self.frame = rect;
        
        CGRect rect2 = self.self.helperHideView.frame;
        self.originHelperViewFrame = rect2;
        CGPoint origin2 = CGPointMake(0, offsetY + 30 -height);
        rect2.origin = origin2;
        self.helperHideView.frame = rect2;
        
        CGRect rect1 = self.detailView.frame;
        self.originDetailViewFrame = rect1;
        CGPoint origin1 = CGPointMake(0, 100 + 30 + offsetY);
        rect1.origin = origin1;
        self.detailView.frame = rect1;
        
        [self addShadowWithView:self];
        [self addShadowWithView:self.detailView];
        [self.detailButton setTitle:@"X" forState:UIControlStateNormal];
        
    }];
    self.detailButton.tag = 1;
}

- (void)addSelectBlock:(MMCellDeselectBlock)block
{
    _selectBlock = block;
}

- (void)addDeselectBlock:(MMCellDeselectBlock)block
{
    _deselectBlock = block;
}



- (void)addShadowWithView:(UIView *)view {
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:0.3];
    [view.layer setShadowRadius:3.0];
    [view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}







- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
