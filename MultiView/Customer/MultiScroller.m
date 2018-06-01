//
//  MultiScroller.m
//  MultiView
//
//  Created by liangchengyou on 2018/6/1.
//  Copyright © 2018年 liangchengyou. All rights reserved.
//

#import "MultiScroller.h"
#import "Person.h"
#import "TestCell.h"
#import <Masonry/Masonry.h>

static NSString *cellident = @"testCell";

@interface MultiScroller()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *tabArray;
@property (nonatomic, assign) NSInteger tabNum;
@property (nonatomic, strong) NSMutableArray *dataAry;
@end

@implementation MultiScroller

-(instancetype)initWithFrame:(CGRect)frame numTab:(NSInteger)numTab {
    self = [super initWithFrame:frame];
    if (self) {
        _tabArray = [NSMutableArray array];
        _dataAry = [NSMutableArray array];
        _tabNum = numTab;
        self.bounces = NO;
        self.directionalLockEnabled = YES;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*_tabNum, self.frame.size.height);
        [self createUI];
    }
    return self;
}

-(void)createUI {
    for (int i = 0; i < _tabNum; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tag = 3000+i;
        tableView.delegate = self;
        tableView.dataSource = self;
        [_tabArray addObject:tableView];
        [self addSubview:tableView];
    }
    
    for (int i = 0; i < _tabArray.count; i++) {
        UITableView *tab = [_tabArray objectAtIndex:i];
        [tab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(self);
            make.left.mas_equalTo([UIScreen mainScreen].bounds.size.width*i);
        }];
    }
}

-(void)upDataContent:(NSMutableArray *)dataAry indext:(NSInteger)indext {
    _dataAry = dataAry;
    if (indext == -1) {
        for (UITableView *tab in _tabArray) {
            [tab reloadData];
        }
    }else {
        UITableView *tab = [_tabArray objectAtIndex:indext];
        [tab reloadData];
    }
}

#pragma mark - tabViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identfier = @"cell";
    
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TestCell" owner:nil options:nil].firstObject;
    }
    if (_dataAry.count > 0) {
        NSArray *array = [_dataAry objectAtIndex:tableView.tag-3000];
        Person *person = [array objectAtIndex:indexPath.row];
        cell.namelabel.text = person.name;
        cell.agelabel.text = [NSString stringWithFormat:@"%ld",(long)person.age];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger indext = tableView.tag-3000;
    if (_dataAry.count > 0) {
        NSMutableArray *array = [_dataAry objectAtIndex:indext];
        return array.count;
    }else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 153.5;
}

-(void)upDataContentOffset:(NSInteger)indext {
    self.contentOffset = CGPointMake(indext*[UIScreen mainScreen].bounds.size.width, 0);
}

@end
