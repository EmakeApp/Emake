//
//  YHSuperGroupTableViewCell.h
//  emake
//
//  Created by zhangshichao on 2018/9/13.
//  Copyright © 2018年 emake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHSuperGroupModel.h"
@interface YHSuperGroupTableViewCell : UITableViewCell
@property(nonatomic,strong) UIButton *togetherButton;
//@property(nonatomic,strong) UIButton *inviteButton;
@property(nonatomic,strong)UILabel *dateEnd;

-(void)requestData:(YHSuperGroupModel *)model;
@end
