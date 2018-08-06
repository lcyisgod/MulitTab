//
//  DateOperaViewController.m
//  MultiView
//
//  Created by liangchengyou on 2018/8/3.
//  Copyright © 2018年 liangchengyou. All rights reserved.
//

#import "DateOperaViewController.h"
#import <FMDB/FMDB.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Person.h"
#import "TestCell.h"

@interface DateOperaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *baseTable;
@property (nonatomic, strong) NSMutableArray *dataArray;
//数据库
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation DateOperaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setTitle:@"数据库操作"];
    [self.view addSubview:self.baseTable];
    _dataArray = [NSMutableArray array];
    [self createDB];
    [self operData];
//    [self selectDataFromDB];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(delatePerson)];
    [self.navigationItem setRightBarButtonItem:barButton];
}

-(UITableView *)baseTable {
    if (!_baseTable) {
        _baseTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _baseTable.delegate = self;
        _baseTable.dataSource = self;
    }
    return _baseTable;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identfier = @"cell";
    
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TestCell" owner:nil options:nil].firstObject;
    }
    if (_dataArray.count > 0) {
        Person *person = [_dataArray objectAtIndex:indexPath.row];
        cell.namelabel.text = person.name;
        cell.agelabel.text = [NSString stringWithFormat:@"%ld",(long)person.age];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

//添加数据
-(void)operData {
    if (![self.db open]) {
        NSLog(@"打开失败");
        return;
    }
    __weak typeof(self) weakSelf = self;
    __strong typeof(weakSelf) strongSelf = weakSelf;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@",[NSDate date]);
        for (int i = 0; i < 1000; i++) {
            Person *person = [[Person alloc] init];
            person.ID = i;
            person.name = i%2==0?@"张三":@"李四";
            person.age = arc4random()%30;
            person.sex = i%3==0?@"男":@"女";
            NSString *insertsql = @"insert into 'person'(ID,name,sex,age) values(?,?,?,?)";
            BOOL insertResult = [weakSelf.db executeUpdate:insertsql withArgumentsInArray:@[[NSNumber numberWithInt:person.ID],person.name,person.sex,[NSNumber numberWithInt:person.age]]];
            if (insertResult) {
                NSLog(@"插入成功");
            }
        };
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",[NSThread currentThread]);
            if (![strongSelf.db close]) {
                NSLog(@"关闭失败");
            }else {
                NSLog(@"%@",[NSDate date]);
                [self selectDataFromDB];
            }
        });
    });
}

//搜索
-(void)selectDataFromDB {
    NSLog(@"%@",[NSThread currentThread]);
    if (![self.db open]) {
        NSLog(@"打开失败");
        return;
    }
    __weak typeof(self) weakSelf = self;
    __strong typeof(weakSelf) strongSelf = weakSelf;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@",[NSThread currentThread]);
        FMResultSet *resultSelect = [strongSelf.db executeQuery:@"select * from person"];
        while ([resultSelect next]) {
            Person *person = [[Person alloc] init];
            person.ID = [[resultSelect stringForColumn:@"ID"] intValue];
            person.name = [resultSelect stringForColumn:@"name"];
            person.sex = [resultSelect stringForColumn:@"sex"];
            person.age = [[resultSelect stringForColumn:@"age"] intValue];
            [strongSelf.dataArray addObject:person];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.db close];
            [strongSelf.baseTable reloadData];
        });
    });
}

//删除
-(void)delatePerson {
    if (![self.db open]) {
        NSLog(@"打开失败");
        return;
    }
    __weak typeof(self) weakSelf = self;
    __strong typeof(weakSelf) strongSelf = weakSelf;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL result = [strongSelf.db executeUpdate:@"delete from 'person' where ID = ?" withArgumentsInArray:@[@0]];
        if (result) {
            NSLog(@"删除成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![strongSelf.db close]) {
                    NSLog(@"关闭失败");
                }else {
                    for (Person *per in strongSelf.dataArray) {
                        if (per.ID == 0) {
                            [strongSelf.dataArray removeObject:per];
                            break;
                        }
                    }
                    [strongSelf.baseTable reloadData];
                }
            });
        }else {
            NSLog(@"删除失败");
        }
    });
}


-(FMDatabase *)db {
    if (!_db) {
        NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath = [docuPath stringByAppendingString:@"person.db"];
        _db = [FMDatabase databaseWithPath:dbPath];
    }
    return _db;
}

-(void)createDB {
    if (![self.db open]) {
        NSLog(@"打开失败");
        return;
    }
    NSString *sql = @"create table if not exists person ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'name' TEXT NOT NULL, 'sex' TEXT NOT NULL,'age' INTEGER NOT NULL)";
    BOOL result = [_db executeUpdate:sql];
    if (result) {
        NSLog(@"创建成功");
    }
    if (![_db close]) {
        NSLog(@"关闭失败");
    }
}

-(void)dealloc {
    NSLog(@"销毁了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
