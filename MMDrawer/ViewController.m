//
//  ViewController.m
//  MMDrawer
//
//  Created by 张明 on 17/3/21.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "ViewController.h"
#import "MMArticleModel.h"
#import "MMTableViewCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDatasource];
  
}
- (void)setupDatasource
{
    self.dataArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        MMArticleModel *model = [[MMArticleModel alloc] init];
        model.title = [NSString stringWithFormat:@"我是标题%ld",i];
        model.updateTime = [NSString stringWithFormat:@"update %ld 小时以前",i];
        model.author = @"MZhang";
        model.createTime = [NSString stringWithFormat:@"createTime%ld小时以前",i];
        model.image = [UIImage imageNamed:@"1.jpg"];
        model.content = [NSString stringWithFormat:@"我是第%ld篇的内容详情",i];
        [self.dataArr addObject:model];
    }
    [self.tableView registerClass:[MMTableViewCell class] forCellReuseIdentifier:MMTableViewCellIdentifier];
    
}
- (void)tableView:(UITableView *)tableView selectCellAtIndexPath:(NSIndexPath *)indexPath {
    MMTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.tableView bringSubviewToFront:cell];
    for (UIView *subcell in tableView.visibleCells) {
        if (subcell != cell) {
            subcell.alpha = 0;
        }
    }
    
    tableView.allowsSelection = NO;
    tableView.scrollEnabled = NO;
    [cell selectToShowDetailWithContentOffsetY:tableView.contentOffset.y];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MMTableViewCellIdentifier];
    [cell configCellWithArticleModel:self.dataArr[indexPath.row]];
    [cell addSelectBlock:^{
        [self tableView:tableView selectCellAtIndexPath:indexPath];
    }];
    [cell addDeselectBlock:^{
        for (UIView *subcell in tableView.visibleCells) {
            if (subcell != cell) {
                subcell.alpha = 1;
            }
        }
        tableView.allowsSelection = YES;
        tableView.scrollEnabled = YES;
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self tableView:tableView selectCellAtIndexPath:indexPath];
    
    //    GCTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    [self.tableView bringSubviewToFront:cell];
    //    for (UIView *subcell in tableView.visibleCells) {
    //        if (subcell != cell) {
    //            subcell.alpha = 0;
    //        }
    //    }
    //
    //    tableView.allowsSelection = NO;
    //    tableView.scrollEnabled = NO;
    //    [cell selectToShowDetailWithContentOffsetY:tableView.contentOffset.y];
}






@end
