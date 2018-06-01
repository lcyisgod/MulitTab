//
//  MultiView.h
//  MultiView
//
//  Created by liangchengyou on 2018/6/1.
//  Copyright © 2018年 liangchengyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiView : UIView
-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titlerArry;
//-1 刷新所有
-(void)upDataContent:(NSMutableArray *)dataAry indext:(NSInteger)indext;
@end
