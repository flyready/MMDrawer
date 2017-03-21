//
//  MMArticleModel.h
//  MMDrawer
//
//  Created by 张明 on 17/3/21.
//  Copyright © 2017年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MMArticleModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSUInteger commentsCount;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *content;
@end
