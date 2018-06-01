//
//  MultiScroller.h
//  MultiView
//
//  Created by liangchengyou on 2018/6/1.
//  Copyright © 2018年 liangchengyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiScroller : UIScrollView
-(instancetype)initWithFrame:(CGRect)frame numTab:(NSInteger)numTab;
//-1 刷新所有
-(void)upDataContent:(NSMutableArray *)dataAry indext:(NSInteger)indext;
//更改范围
-(void)upDataContentOffset:(NSInteger)indext;
@end
