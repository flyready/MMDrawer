//
//  MMTableViewCell.h
//  MMDrawer
//
//  Created by 张明 on 17/3/21.
//  Copyright © 2017年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMArticleModel;
FOUNDATION_EXPORT NSString *const MMTableViewCellIdentifier;
typedef void(^MMCellSelectBlock)();
typedef void(^MMCellDeselectBlock)();
@interface MMTableViewCell : UITableViewCell
- (void)addSelectBlock:(MMCellDeselectBlock)block;
- (void)addDeselectBlock:(MMCellDeselectBlock)block;
- (void)selectToShowDetailWithContentOffsetY:(CGFloat)offsetY;
- (void)configCellWithArticleModel:(MMArticleModel *)articleModel;


@end
