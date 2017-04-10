//
//  BaseSubScene.m
//  HDFScrollTableScene
//
//  Created by hdf on 2017/4/10.
//  Copyright © 2017年 hdf. All rights reserved.
//

#import "BaseSubScene.h"
#import "SubCell.h"
@interface BaseSubScene ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *mainTableView;

@end

@implementation BaseSubScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-35) style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableFooterView = [UIView new];
        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
}

#pragma mark UITableViewDelegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self numberOfCell];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 96;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SubCell *cell  = (SubCell *)[tableView dequeueReusableCellWithIdentifier: @"CellId"];
    if (!cell) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSArray *array = [bundle loadNibNamed:@"SubCell" owner:nil options:nil];
        for (id object in array) {
            if ([object isKindOfClass:[SubCell class]]) {
                cell = (SubCell *)object;
                break;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(int)numberOfCell{
    return 2;
}
@end
