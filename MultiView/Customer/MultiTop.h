//
//  MultiTop.h
//  MultiView
//
//  Created by liangchengyou on 2018/6/1.
//  Copyright © 2018年 liangchengyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickDeleate <NSObject>
-(void)selectButton:(NSInteger)indext;
@end
@interface MultiTop : UIView
@property (nonatomic, assign) id<ClickDeleate> delegate;
-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titlerArry;
-(void)upDataButton:(NSInteger)indext;
@end
