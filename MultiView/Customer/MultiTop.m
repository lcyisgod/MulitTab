//
//  MultiTop.m
//  MultiView
//
//  Created by liangchengyou on 2018/6/1.
//  Copyright © 2018年 liangchengyou. All rights reserved.
//

#import "MultiTop.h"
#import <Masonry/Masonry.h>

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width

@interface MultiTop()

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) NSInteger lastIndext;

@end
@implementation MultiTop

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titlerArry {
    self = [super initWithFrame:frame];
    if (self) {
        _buttonArray = [NSMutableArray array];
        _titleArray = titlerArry;
        _lastIndext = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

-(void)createUI {
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        button.tag = 2000+i;
        [button addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonArray addObject:button];
        [self addSubview:button];
    }
    
    for (int i = 0; i < _buttonArray.count; i++) {
        UIButton *button = [_buttonArray objectAtIndex:i];
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(self);
            make.left.mas_equalTo(SCREEN_WIDTH/self.buttonArray.count*i);
            make.width.mas_equalTo(SCREEN_WIDTH/self.buttonArray.count);
        }];
    }
}


-(void)clickEvent:(UIButton *)sender {
    UIButton *lastButton = [_buttonArray objectAtIndex:_lastIndext];
    [lastButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _lastIndext = sender.tag - 2000;
    
    if ([self.delegate respondsToSelector:@selector(selectButton:)]) {
        [self.delegate selectButton:_lastIndext];
    }
}

-(void)upDataButton:(NSInteger)indext {
    UIButton *lastButton = [_buttonArray objectAtIndex:_lastIndext];
    [lastButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIButton *sender = [_buttonArray objectAtIndex:indext];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _lastIndext = sender.tag - 2000;
}

@end
