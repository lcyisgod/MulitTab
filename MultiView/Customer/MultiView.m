//
//  MultiView.m
//  MultiView
//
//  Created by liangchengyou on 2018/6/1.
//  Copyright © 2018年 liangchengyou. All rights reserved.
//

#import "MultiView.h"
#import "MultiTop.h"
#import "MultiScroller.h"
#import <Masonry/Masonry.h>


@interface MultiView()<UIScrollViewDelegate,ClickDeleate>
@property (nonatomic, strong) NSArray *titleAry;
@property (nonatomic, strong) MultiTop *topView;
@property (nonatomic, strong) MultiScroller *scroller;
@end
@implementation MultiView

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titlerArry {
    self = [super initWithFrame:frame];
    if (self) {
        _titleAry = titlerArry;
        [self createUI];
    }
    return self;
}

-(void)createUI {
    [self addSubview:self.topView];
    [self addSubview:self.scroller];
    
    [_topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    [_scroller mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.topView.mas_bottom);
    }];
}

-(MultiTop *)topView {
    if (!_topView) {
        self.topView = [[MultiTop alloc] initWithFrame:CGRectZero titleArray:_titleAry];
        self.topView.delegate = self;
    }
    return _topView;
}

-(MultiScroller *)scroller {
    if (!_scroller) {
        self.scroller = [[MultiScroller alloc] initWithFrame:CGRectZero numTab:_titleAry.count];
        self.scroller.delegate = self;
    }
    return _scroller;
}

-(void)upDataContent:(NSMutableArray *)dataAry indext:(NSInteger)indext {
    [_scroller upDataContent:dataAry indext:indext];
}

-(void)selectButton:(NSInteger)indext {
    [_scroller upDataContentOffset:indext];
}

#pragma mark - ScrollerViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger indext = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    [_topView upDataButton:indext];
}

@end
