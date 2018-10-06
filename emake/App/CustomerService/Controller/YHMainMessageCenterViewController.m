//
//  YHMainMessageCenterViewController.m
//  emake
//
//  Created by 谷伟 on 2018/3/27.
//  Copyright © 2018年 emake. All rights reserved.
//

#import "YHMainMessageCenterViewController.h"
#import "InfomationItemCell.h"
#import "YHSixTeamViewController.h"
#import "InviteMessageCellTableViewCell.h"
#import "YHInviteMessageModel.h"
#import "ChatNewViewController.h"
#import "FMDBManager.h"
#import "ChatCommmonListCell.h"
#import "MQTTCommandModel.h"
#import "chatUserModel.h"
#import "YHMessageLogistTableViewCell.h"
#import "YHLookUpLogisticsViewController.h"
#import "YHSendFileTipsView.h"
#import "YHStoreModel.h"
@interface YHMainMessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource,YHSendFileTipsViewDelegete>

@property (nonatomic,retain)NSMutableArray *infoArray;
@property (nonatomic,strong)UIView *inviteView;
@property (nonatomic,strong)UIView *logisticView;
@property (nonatomic,strong)UIView *notificationView;
@property (nonatomic,strong)UIView *EmptyView;
@property (nonatomic,assign)BOOL isSotre;
@property (nonatomic,strong)NSMutableDictionary * messageCountDic;
@property (nonatomic,strong)NSArray * logistArray;
@property (nonatomic,assign)NSInteger  recordTopButtonPosition;
@property (nonatomic,assign)NSInteger  recordRow;

@end

@implementation YHMainMessageCenterViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.recordTopButtonPosition = 0;

    [self messageRefresh];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    self.view.backgroundColor = TextColor_F5F5F5;
    NSString *isStoreStr = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_ISSTORE];
    self.isSotre = [isStoreStr isEqualToString:@"1"];
    [self configSubViews];
   

    if (self.isSotre) {
        NSArray *listArray = [[FMDBManager sharedManager] getAllMessageChatList];
        self.chatListArray = [NSMutableArray arrayWithArray:listArray];
//        [self configTableView];
    }else{
        [self getMessageList];
    }
    [self configTableView];
    [self getLogistInfoMessageList];


}

- (void)configSubViews{
    
    self.inviteView = [self getPictureWithTextViewWithTag:0 andText:self.isSotre==YES?@"消息":@"邀请" imageString:self.isSotre==YES?@"xiaoxi_xiaoxis":@"xiaoxi-yaoqings"];
    self.inviteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.inviteView];
    
    [self.inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(TOP_BAR_HEIGHT);
        make.width.mas_equalTo(ScreenWidth/3);
        make.height.mas_equalTo(HeightRate(88));
    }];
    
    self.logisticView = [self getPictureWithTextViewWithTag:1 andText:@"交易物流" imageString:@"xiaoxi-wuliu"];
    self.logisticView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.logisticView];
    
    [self.logisticView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(TOP_BAR_HEIGHT);
        make.width.mas_equalTo(ScreenWidth/3);
        make.height.mas_equalTo(HeightRate(88));
    }];
    
    self.notificationView = [self getPictureWithTextViewWithTag:2 andText:@"通知消息" imageString:@"xiaoxi-tongzhi"];
    self.notificationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.notificationView];
    
    [self.notificationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(TOP_BAR_HEIGHT);
        make.width.mas_equalTo(ScreenWidth/3);
        make.height.mas_equalTo(HeightRate(88));
    }];
    
}
- (UIView *)getPictureWithTextViewWithTag:(NSInteger)tag andText:(NSString *)text imageString:(NSString *)imageString{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WidthRate(88), WidthRate(88))];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(goSelectVC:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    [view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageString]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.tag = 1000;
    [view addSubview:image];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WidthRate(17));
        make.centerX.mas_equalTo(view.mas_centerX);
        make.width.mas_equalTo(39);
        make.height.mas_equalTo(39);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.textColor = TextColor_617393;
    label.font = SYSTEM_FONT(AdaptFont(13));
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.top.mas_equalTo(image.mas_bottom).offset(WidthRate(2));
    }];
    
    return view;
}
- (void)configTableView{
    self.messageTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.messageTable.dataSource = self;
    self.messageTable.delegate = self;
    self.messageTable.separatorColor = [UIColor clearColor];
    self.messageTable.backgroundColor = [UIColor clearColor];
    self.messageTable.showsVerticalScrollIndicator = NO;
    self.messageTable.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)){
        self.messageTable.estimatedSectionFooterHeight = TableViewFooterNone;
        self.messageTable.estimatedSectionHeaderHeight = TableViewHeaderNone;
    }
    
    
    self.messageTable.estimatedRowHeight = 0;
    [self.view addSubview:self.messageTable];
    
    [self.messageTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo((TOP_BAR_HEIGHT) + HeightRate(88));
        make.bottom.mas_equalTo(0);
    }];
}
- (void)configEmptyView{
    if (self.EmptyView==nil) {
        self.EmptyView = [[UIView alloc]init];
        self.EmptyView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.EmptyView];
        
        [self.EmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo((TOP_BAR_HEIGHT) + HeightRate(98));
            make.bottom.mas_equalTo(0);
        }];
        
        
        UIImageView *emptyImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queyimianpeitu"]];
        self.EmptyView.contentMode = UIViewContentModeScaleAspectFit;
        [self.EmptyView addSubview:emptyImage];
        
        [emptyImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.EmptyView.mas_centerX);
            make.top.mas_equalTo(HeightRate(70));
            make.width.mas_equalTo(WidthRate(100));
            make.height.mas_equalTo(WidthRate(100));
        }];
        
        UILabel *labelText = [[UILabel alloc]init];
        labelText.text = @"亲！您还没有相关消息哦。";
        labelText.font = SYSTEM_FONT(AdaptFont(12));
        [self.EmptyView addSubview:labelText];
        
        
        [labelText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.EmptyView.mas_centerX);
            make.top.mas_equalTo(emptyImage.mas_bottom).offset(HeightRate(10));
        }];
    }else
    {
        self.EmptyView.hidden = false;
    }
    
}

- (void)goSelectVC:(UIButton *)sender{
    sender.selected = !sender.selected;
    switch(sender.tag) {
        case 0:{
            UIImageView *inviteImage = (UIImageView *)[self.inviteView viewWithTag:1000];
            inviteImage.image = [UIImage imageNamed:@"xiaoxi_xiaoxis"];
            
            UIImageView *logisticImage = (UIImageView *)[self.logisticView viewWithTag:1000];
            logisticImage.image = [UIImage imageNamed:@"xiaoxi-wuliu"];
            
            UIImageView *notificationImage = (UIImageView *)[self.notificationView viewWithTag:1000];
            notificationImage.image = [UIImage imageNamed:@"xiaoxi-tongzhi"];
            self.recordTopButtonPosition = 0;

            [self messageRefresh];
        }
            break;
        case 1:{
            UIImageView *inviteImage = (UIImageView *)[self.inviteView viewWithTag:1000];
            inviteImage.image = [UIImage imageNamed:@"xiaoxi_xiaoxi"];
            
            UIImageView *logisticImage = (UIImageView *)[self.logisticView viewWithTag:1000];
            logisticImage.image = [UIImage imageNamed:@"xiaoxi-wulius"];
            
            UIImageView *notificationImage = (UIImageView *)[self.notificationView viewWithTag:1000];
            notificationImage.image = [UIImage imageNamed:@"xiaoxi-tongzhi"];
            self.recordTopButtonPosition = 1;
            if (self.logistArray.count >0) {
                
                self.messageTable.hidden = false;
                [self.messageTable reloadData];
                self.EmptyView.hidden = YES;
            }else{
                self.messageTable.hidden = YES;
                [self configEmptyView];
            }
        }
            break;
        case 2:{
            UIImageView *inviteImage = (UIImageView *)[self.inviteView viewWithTag:1000];
            inviteImage.image = [UIImage imageNamed:@"xiaoxi_xiaoxi"];
            
            UIImageView *logisticImage = (UIImageView *)[self.logisticView viewWithTag:1000];
            logisticImage.image = [UIImage imageNamed:@"xiaoxi-wuliu"];
            
            UIImageView *notificationImage = (UIImageView *)[self.notificationView viewWithTag:1000];
            notificationImage.image = [UIImage imageNamed:@"xiaoxi-tongzhis"];
            self.recordTopButtonPosition = 1;
            self.messageTable.hidden = YES;
            [self configEmptyView];
        }
            break;
        default:
            break;
    }
}
- (void)getMessageList{
    _recordTopButtonPosition = 0;
    [self.view showWait:@"加载中" viewType:CurrentView];
    self.infoArray = [NSMutableArray arrayWithCapacity:0];
    [[YHJsonRequest shared] getMessageListSuccessBlock:^(NSArray *messageList) {
        [self.view hideWait:CurrentView];
        self.infoArray = [NSMutableArray arrayWithArray:messageList];
        if (self.infoArray.count >0) {
            self.messageTable.hidden = false;
            [self.messageTable reloadData];
            self.EmptyView.hidden = YES;
        }else{
            self.messageTable.hidden = YES;
            [self configEmptyView];
        }
    } fialureBlock:^(NSString *errorMessages) {
       
        [self.view hideWait:CurrentView];
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}

- (void)getLogistInfoMessageList{

//    [self.view showWait:@"加载中" viewType:CurrentView];
    [[YHJsonRequest shared] getLogistMessageInfoWithParams:nil SuccessBlock:^(NSArray *successArray) {
        self.logistArray = [NSMutableArray arrayWithArray:successArray];

    } fialureBlock:^(NSString *errorMessages) {
        [self.view hideWait:CurrentView];
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
     
   
}
- (void)joinTeam:(UIButton *)sender{
    [self.view showWait:@"加载中" viewType:CurrentView];
    YHInviteMessageModel *model = self.infoArray[sender.tag-1000];
    NSDictionary *parameter = @{@"MobileNumber":model.MobileNumber};
    [[YHJsonRequest shared] joinTeam:parameter SuccessBlock:^(NSString *successMessage) {
        [self.view hideWait:CurrentView];
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:LOGIN_USERTYPE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self getMessageList];
    } fialureBlock:^(NSString *errorMessages) {
        [self.view hideWait:CurrentView];
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}
#pragma mark==== UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.recordTopButtonPosition == 0) {
        return 1;
    }else
    {
        return 1;
    }
}
-(void)messageRefresh
{
    NSArray *listArray = [[FMDBManager sharedManager] getAllMessageChatList];
    self.chatListArray = [NSMutableArray arrayWithArray:listArray];
    SDChatMessage * msg = [[FMDBManager sharedManager] getMessageChatListWithOffcial];
    msg.staffName = @"易智造客服";
    if (msg.msg.length>0 ) {
        
        [self.chatListArray addObject:msg];
        
    }
    NSMutableDictionary *messageCountDic = [YHMQTTClient sharedClient].messageCountDic;
    if ([messageCountDic.allKeys containsObject:@"官方客服"]) {
         [self.messageTable reloadData];
            self.messageTable.hidden = false;
            self.EmptyView.hidden = YES;
    }else
    {
        if (self.chatListArray.count == 0) {
            self.messageTable.hidden = YES;
            [self configEmptyView];
        }else
        {
            self.messageTable.hidden = false;
            self.EmptyView.hidden = YES;
            [self.messageTable reloadData];
        }
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSotre) {
        if (self.recordTopButtonPosition == 0) {
            
//            if (section == 0) {
//                return 1;
//            }else{
            NSMutableDictionary *messageCountDic = [YHMQTTClient sharedClient].messageCountDic;
//            if ([messageCountDic.allKeys containsObject:@"官方客服"]) {
//                return self.chatListArray.count+1;
//
//            }else
//            {
                return self.chatListArray.count;

//            }
//            }
        }else if (self.recordTopButtonPosition == 1)
        {
//            return 3;

            return self.logistArray.count;
        }else
        {
            return 0;
        }
    }else{
        return self.infoArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSotre) {
        if (self.recordTopButtonPosition == 0) {
            NSMutableDictionary *messageCountDic = [YHMQTTClient sharedClient].messageCountDic;
            self.messageCountDic = messageCountDic;
            ChatCommmonListCell *cell = nil;
            if (cell == nil) {
                cell = [[ChatCommmonListCell alloc]init];
            }
            SDChatMessage *msg = self.chatListArray[indexPath.row];
            if (msg.userId.length>0) {
                if ([msg.staffName isEqualToString:@"易智造客服"]) {
                    msg.messageCount = messageCountDic[@"官方客服"];
                    
                }else
                {
                    msg.messageCount = messageCountDic[msg.userId];
                    
                }
            }
            
            [cell setData:msg];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }else if(self.recordTopButtonPosition == 1)
        {
            YHMessageLogistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHMessageLogistTableViewCell"];
            if (cell ==nil) {
                cell = [[YHMessageLogistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YHMessageLogistTableViewCell"];

            }
            YHLogistInfoModel *model =self.logistArray[indexPath.row];
            
            [cell setDataModel:model];
            return cell;
            
            
        }else
        {
            
            return nil;
        }
            
        
    }else{
        InviteMessageCellTableViewCell *cell = nil;
        if (cell == nil) {
            cell = [[InviteMessageCellTableViewCell alloc]init];
        }
        YHInviteMessageModel *model = self.infoArray[indexPath.row];
        [cell setData:model];
        cell.agree.tag = 1000 +indexPath.row;
        [cell.agree addTarget:self action:@selector(joinTeam:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.recordTopButtonPosition ==1) {
        return HeightRate(80);
    }
    return HeightRate(67.0);
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSotre) {
        
    }else{
        [self.view showWait:@"请等待" viewType:CurrentView];
        YHInviteMessageModel *model = self.infoArray[indexPath.row];
        [[YHJsonRequest shared] deleteInfomationList:model.RefNo SuccessBlock:^(NSString *successMessage) {
            [self.view makeToast:successMessage duration:1.0 position:CSToastPositionCenter];
            [self.view hideWait:CurrentView];
            [self.infoArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
            
        } fialureBlock:^(NSString *errorMessages) {
            [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
            [self.view hideWait:CurrentView];
        }];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        
        if(self.recordTopButtonPosition == 1){
            YHLogistInfoModel *model = self.logistArray[indexPath.row];
            YHLookUpLogisticsViewController *vc = [[YHLookUpLogisticsViewController alloc] init];
            vc.logsticsNumber = model.ContractNo;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(self.recordTopButtonPosition == 0){
            
            if (self.fileNameStr.length > 0) {
                self.recordRow = indexPath.row;
                YHSendFileTipsView *FileTipsView = [[YHSendFileTipsView alloc] initWithDelegete:self andFileurl:self.urlStr andFileName:self.fileNameStr];
                [FileTipsView showAnimated];
            }else{
                
                NSInteger count = [self.messageCountDic[@"messageCount"] integerValue];
                NSMutableDictionary *messageDictionary = [NSMutableDictionary dictionary];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
                ChatNewViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Chat"];
                
                
                SDChatMessage *msg = self.chatListArray[indexPath.row];
                NSDictionary *dict = [msg.Group mj_JSONObject];
                YHGroupModel *model = [YHGroupModel mj_objectWithKeyValues:dict];
                vc.storeName = model.GroupName;
                vc.storeAvata = model.GroupPhoto;
//                vc.listID = msg.userId;
                if ([msg.staffName  isEqualToString:@"易智造客服"]) {
                    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_USERID];
                    vc.listID = userID;
                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"MessageDic"];
                    SDChatMessage * msg = [[FMDBManager sharedManager] getMessageChatListWithOffcial];
                    NSInteger count1 = [self.messageCountDic[@"官方客服"] integerValue];
                    count = count-count1;
                    if (msg.userId.length>0) {
                        [[YHMQTTClient sharedClient].messageCountDic setObject:@(0) forKey:@"官方客服"];
                        
                    }
                }else{
                    
                    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_USERID];
                    NSDictionary *dict = [msg.Group mj_JSONObject];
                    YHGroupModel *model = [YHGroupModel mj_objectWithKeyValues:dict];
                    vc.ChatVCTitle = model.GroupName;
//                    vc.isCatagory = msg.
                    if ([msg.userId containsString:@"_"]) {
                        NSArray *array = [msg.userId componentsSeparatedByString:@"_"];
                        if (array.count == 2) {
                            vc.storeID = array[0];
                            [[YHMQTTClient sharedClient] sendRequestChatroomCustomerListCMDWith:userID andStoreId:array[0]];
                            vc.listID = [NSString stringWithFormat:@"%@_%@",array[0],userID];

                        }
                    }
                    NSInteger count1 = [self.messageCountDic[msg.userId] integerValue];
                    count = count-count1;
                    if (msg.userId.length>0) {
                        [[YHMQTTClient sharedClient].messageCountDic setObject:@(0) forKey:msg.userId];
                        
                    }
                }
                
                [messageDictionary setObject:@(count) forKey:@"messageCount"];
                [[YHMQTTClient sharedClient].messageCountDic setObject:@(count) forKey:@"messageCount"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }

           
        }
}

- (void)alertViewRightBtnClick:(id)alertView withFileUrl:(NSString *)fileurl withfileName:(NSString *)fileName{
//    UIView *alert = (UIView *)alertView;
    SDChatMessage *msg = self.chatListArray[self.recordRow];

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileurl]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    ChatNewViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Chat"];
    NSString *messageIdString = [[NSUUID UUID] UUIDString];
    vc.filePath = messageIdString;
    vc.fileName = fileName;
    vc.fileData = data;
    vc.isUploadFile = YES;
   
    if ([msg.staffName isEqualToString:@"官方客服"]) {
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_USERID];
        vc.listID = userID;
    }else
    {
        vc.storeName = msg.staffName;
        vc.storeAvata = msg.staffAvata;
        vc.storeName = msg.staffName;
        if ([msg.userId containsString:@"_"]) {
            NSArray *array = [msg.userId componentsSeparatedByString:@"_"];
            if (array.count == 2) {
                vc.storeID = array[0];
                vc.listID = [NSString stringWithFormat:@"%@_%@",array[0],msg.userId];

            }
        }
    }
    self.fileNameStr = @"";
    self.urlStr =@"";
    [vc sendCMDRequestService];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:false];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue s            ender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end