//
//  YHWithDrawListViewController.m
//  emake
//
//  Created by 谷伟 on 2018/1/5.
//  Copyright © 2018年 emake. All rights reserved.
//

#import "YHWithDrawListViewController.h"
#import "YHWithDrawListCell.h"
@interface YHWithDrawListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)UIView *emptyView;
@property (nonatomic,strong)NSMutableArray *depositList;
@end

@implementation YHWithDrawListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现明细";
    self.view.backgroundColor = TextColor_F5F5F5;
    [self addRigthDetailButtonIsShowCart:false];
    [self getDepositList];
}
- (void)configSubViews{
    
    self.table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.estimatedSectionFooterHeight = 0;
    self.table.estimatedSectionHeaderHeight = 0;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.showsVerticalScrollIndicator = false;
    self.table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.table];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(TOP_BAR_HEIGHT);
        make.height.mas_equalTo(ScreenHeight-(TOP_BAR_HEIGHT));
    }];
}
- (void)configEmptyViews{
    
    self.emptyView = [[UIView alloc]init];
    [self.view addSubview:self.emptyView];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(TOP_BAR_HEIGHT);
        make.height.mas_equalTo(ScreenHeight-(TOP_BAR_HEIGHT));
    }];
    
    UIImageView *emptyImage = [[UIImageView alloc]init];
    emptyImage.contentMode = UIViewContentModeScaleAspectFit;
    emptyImage.image = [UIImage imageNamed:@"zanwupinpai"];
    [self.emptyView addSubview:emptyImage];
    
    [emptyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WidthRate(200));
        make.height.mas_equalTo(HeightRate(210));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(HeightRate(-20));
    }];
    
    UILabel *labelTips = [[UILabel alloc]init];
    labelTips.font = SYSTEM_FONT(AdaptFont(14));
    labelTips.text = @"亲，您还没有提现记录";
    [self.emptyView addSubview:labelTips];
    
    [labelTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(emptyImage.mas_bottom);
    }];
}
- (void)getDepositList{
    [self.view showWait:@"加载中" viewType:CurrentView];
    self.depositList = [NSMutableArray arrayWithCapacity:0];
    [[YHJsonRequest shared] getDepositListSuccessBlock:^(NSArray *listArray) {
        self.depositList = [NSMutableArray arrayWithArray:listArray];
        if (self.depositList.count <=0) {
            [self configEmptyViews];
        }else{
            [self configSubViews];
        }
        [self.view hideWait:CurrentView];
    } fialureBlock:^(NSString *errorMessages) {
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
        [self.view hideWait:CurrentView];
    }];
}
#pragma mark --UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.depositList.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YHWithDrawListCell *cell = nil;
    if (!cell) {
        cell = [[YHWithDrawListCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YHDepositModel *model = [self.depositList objectAtIndex:indexPath.row];
    [cell setData:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HeightRate(73);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end