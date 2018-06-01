//
//  ViewController.m
//  MultiView
//
//  Created by liangchengyou on 2018/6/1.
//  Copyright © 2018年 liangchengyou. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "MultiView.h"
#import "Person.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *titleAry;
@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) MultiView *multView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationItem setTitle:@"首页"];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(upload)];
    [self.navigationItem setRightBarButtonItem:barButton];
    
    _titleAry = @[@"测试1",@"测试2",@"测试3",@"测试4"];
    [self.view addSubview:self.multView];
    
    NSMutableArray *dataAry = [NSMutableArray array];
    for (int i = 0; i < _titleAry.count; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < 1+arc4random()%20; j++) {
            Person *person = [[Person alloc] init];
            person.name = [NSString stringWithFormat:@"张%d%d",i,j];
            person.age = arc4random()%25;
            person.sex = (i+1)*(j+1)/2==0?@"男":@"女";
            [array addObject:person];
        }
        [dataAry addObject:array];
    }
    _dataAry = dataAry;
    [_multView upDataContent:_dataAry indext:-1];
    
    [_multView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)upload {
    [_multView upDataContent:_dataAry indext:-1];
}

-(MultiView *)multView {
    if (!_multView) {
        self.multView = [[MultiView alloc] initWithFrame:CGRectZero titleArray:_titleAry];
    }
    return _multView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
