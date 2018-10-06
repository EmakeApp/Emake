//
//  YHOrderNewFootTableViewCell.m
//  emake
//
//  Created by 张士超 on 2018/5/23.
//  Copyright © 2018年 emake. All rights reserved.
//

#import "YHOrderNewFootTableViewCell.h"

static CGFloat const paidFont = 14;
static CGFloat const ferentFont = 12;

@interface YHOrderNewFootTableViewCell ()



@property (nonatomic,assign)double insuranceRate;

@property (nonatomic,weak)UILabel *insureFee;
@property (nonatomic,weak)UILabel *insureMoney;
@property (nonatomic,weak)UILabel *priceLable;
@property (nonatomic,weak)UILabel *fixlable;
@property (nonatomic,weak)UILabel *tipsRightLable;
@property (nonatomic,weak)UILabel *tipsRightLableTop;

//@property (nonatomic,weak)YHLabel *paidMoneyLabel;
@property (nonatomic,weak)UIView *bordview;

@property(nonatomic,weak)UILabel *payRateNameLabel;
@property(nonatomic,weak)UILabel *payRateBgLabel;
@property (nonatomic,weak)YHLabel *paidMoneyLabel;

@property (nonatomic,weak)UIView *addInsuranceview;
@property (nonatomic,weak)UIView *progressView;

@property (nonatomic,weak)UILabel *stateLable;

@end
@implementation YHOrderNewFootTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *addInsuranceview = [[UIView alloc] init];
//        addInsuranceview.backgroundColor = [UIColor greenColor];
        [self addSubview:addInsuranceview];
        [addInsuranceview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(0));
            make.height.mas_equalTo(HeightRate(64));
            make.width.mas_equalTo(ScreenWidth);
            make.top.mas_equalTo(HeightRate(0));
        }];
        self.addInsuranceview = addInsuranceview;
        
        UIButton *leftTipImage = [[UIButton alloc] init];
        [leftTipImage setImage:[UIImage imageNamed:@"bangzhu1"] forState:UIControlStateNormal];
        [addInsuranceview addSubview:leftTipImage];
        [leftTipImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(10));
            make.height.mas_equalTo(HeightRate(40));
            make.width.mas_equalTo(WidthRate(34));
            make.top.mas_equalTo(HeightRate(10));
        }];
        self.helpBtn = leftTipImage;
        
//        UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [addInsuranceview addSubview:rightbtn];
//        [rightbtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(WidthRate(-10));
//            make.height.mas_equalTo(HeightRate(30));
//            make.width.mas_equalTo(WidthRate(130));
//            make.top.mas_equalTo(HeightRate(10));
//
//        }];
//        self.rightBtn = rightbtn;
        
//        UIImageView *imageright = [[UIImageView alloc] init];
//        imageright.image = [UIImage imageNamed:@"right01"];
//        [addInsuranceview addSubview:imageright];
//        [imageright mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(WidthRate(-10));
//            make.height.mas_equalTo(HeightRate(20));
//            make.width.mas_equalTo(WidthRate(15));
//            make.top.mas_equalTo(HeightRate(15));
//
//        }];
        
        UILabel *insureFee = [[UILabel alloc] init];
        insureFee.textColor = ColorWithHexString(@"5792F0") ;
        insureFee.font = [UIFont systemFontOfSize:AdaptFont(12)];
        insureFee.text = @"111";
        insureFee.textAlignment = NSTextAlignmentRight;
        [addInsuranceview addSubview:insureFee];
        [insureFee mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-10));
            make.height.mas_equalTo(HeightRate(20));
            //        make.width.mas_equalTo(WidthRate(15));
            make.top.mas_equalTo(HeightRate(10));
        }];
        self.insureFee = insureFee;
        
//        UILabel *tipLable = [[UILabel alloc] init];
//        tipLable.textColor = ColorWithHexString(SymbolTopColor) ;
//        tipLable.text = @"(由易智造代收代付)";
//        tipLable.font = [UIFont systemFontOfSize:AdaptFont(12)];
//        [addInsuranceview addSubview:tipLable];
//        [tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(WidthRate(-10));
//            make.height.mas_equalTo(HeightRate(20));
//            //        make.width.mas_equalTo(WidthRate(15));
//            make.top.mas_equalTo(insureFee.mas_bottom).offset(HeightRate(10));
//        }];
//        tipLable.hidden = YES;
        
        UILabel *insureMoney = [[UILabel alloc] init];
        insureMoney.textColor = ColorWithHexString(@"999999") ;
        insureMoney.text = @"111";
        insureMoney.font = [UIFont systemFontOfSize:AdaptFont(12)];
        insureMoney.textAlignment = NSTextAlignmentRight;
        [addInsuranceview addSubview:insureMoney];
        [insureMoney mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(tipLable.mas_left).offset(WidthRate(-5));
            make.right.mas_equalTo(WidthRate(-10));
            make.height.mas_equalTo(HeightRate(20));
            //        make.width.mas_equalTo(WidthRate(15));
            make.top.mas_equalTo(insureFee.mas_bottom).offset(HeightRate(10));
        }];
        self.insureMoney = insureMoney;
        
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = SepratorLineColor;
        [addInsuranceview addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(0));
            make.height.mas_equalTo(HeightRate(1));
            make.width.mas_equalTo(ScreenWidth);
            make.top.mas_equalTo(insureMoney.mas_bottom).offset(HeightRate(10));
//            make.bottom.mas_equalTo(HeightRate(0));

        }];
        
        UILabel *tipsRightLable1 = [[UILabel alloc] init];
        tipsRightLable1.textColor = ColorWithHexString(SymbolTopColor) ;
        tipsRightLable1.font = [UIFont systemFontOfSize:AdaptFont(13)];
        tipsRightLable1.textAlignment = NSTextAlignmentRight;
        [self addSubview:tipsRightLable1];
        [tipsRightLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-10));
            make.height.mas_equalTo(HeightRate(0.01));
            //        make.width.mas_equalTo(WidthRate(15));
            make.top.mas_equalTo(addInsuranceview.mas_bottom).offset(HeightRate(0));

        }];
        self.tipsRightLableTop = tipsRightLable1;
        
        UILabel *priceLable = [[UILabel alloc] init];
        priceLable.textColor = ColorWithHexString(StandardBlueColor) ;
        priceLable.font = [UIFont systemFontOfSize:AdaptFont(14)];
        priceLable.textAlignment = NSTextAlignmentRight;
        [self addSubview:priceLable];
        [priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-10));
            make.height.mas_equalTo(HeightRate(30));
            //        make.width.mas_equalTo(WidthRate(15));
            make.top.mas_equalTo(tipsRightLable1.mas_bottom).offset(HeightRate(5));
            
        }];
        self.priceLable = priceLable;
        
        
        
        UILabel *fixlable = [[UILabel alloc] init];
        fixlable.textColor = ColorWithHexString(@"000000") ;
        fixlable.font = [UIFont systemFontOfSize:AdaptFont(12)];
        fixlable.textAlignment = NSTextAlignmentRight;
        [self addSubview:fixlable];
        [fixlable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(priceLable.mas_left).offset(0);
            make.height.mas_equalTo(HeightRate(30));
            //        make.width.mas_equalTo(WidthRate(15));
            make.top.mas_equalTo(tipsRightLable1.mas_bottom).offset(HeightRate(5));
            
        }];
        self.fixlable = fixlable;
        
        UILabel *tipsRightLable = [[UILabel alloc] init];
        tipsRightLable.textColor = ColorWithHexString(SymbolTopColor) ;
        tipsRightLable.font = [UIFont systemFontOfSize:AdaptFont(13)];
        tipsRightLable.textAlignment = NSTextAlignmentRight;
        [self addSubview:tipsRightLable];
        [tipsRightLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-10));
            make.height.mas_equalTo(HeightRate(30));
            //        make.width.mas_equalTo(WidthRate(15));
            make.top.mas_equalTo(priceLable.mas_bottom).offset(HeightRate(0));
            
        }];
        self.tipsRightLable = tipsRightLable;
        
        UILabel *line2 = [[UILabel alloc] init];
        line2.backgroundColor = SepratorLineColor;
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(0));
            make.height.mas_equalTo(HeightRate(1));
            make.width.mas_equalTo(ScreenWidth);
            make.top.mas_equalTo(tipsRightLable.mas_bottom).offset(HeightRate(10));
            
        }];
//        self.line2= line2;
        
        UIView *item = [self progressView:line2 rate:0.6 name:@"已付金额：" ];

        //         UIView *stateView = [[UIView alloc] init];
//        [self addSubview:stateView];
//        [stateView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(WidthRate(10));
//            make.height.mas_equalTo(HeightRate(30));
//            make.right.mas_equalTo(WidthRate(-10));
//            make.top.mas_equalTo(item.mas_bottom).offset(HeightRate(0));
//        }];
        
        UILabel *stateLable = [[UILabel alloc] init];
        stateLable.textColor = ColorWithHexString(@"666666") ;
        stateLable.text =@"●预付款 ———●生产中———●生产完成 ———●尾款";
        stateLable.font = [UIFont systemFontOfSize:AdaptFont(13)];
        stateLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:stateLable];
        [stateLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(0));
            make.height.mas_equalTo(HeightRate(30));
            make.right.mas_equalTo(WidthRate(0));
            make.top.mas_equalTo(item.mas_bottom).offset(HeightRate(0));
            
        }];
        self.stateLable = stateLable;
        
        UILabel *line22 = [[UILabel alloc] init];
        line22.backgroundColor = SepratorLineColor;
        [self addSubview:line22];
        [line22 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(0));
            make.height.mas_equalTo(HeightRate(1));
            make.width.mas_equalTo(ScreenWidth);
            make.top.mas_equalTo(stateLable.mas_bottom).offset(HeightRate(0));
            
        }];
        
//        YHLogisticsDetailButton *logisticsDetailButton = [YHLogisticsDetailButton initBorderStyleWithTitle:@" 查看物流"];
////        [logisticsDetailButton addTarget:self action:@selector(orderSlectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        self.logisticsDetailButton = logisticsDetailButton;
//        [self addSubview:logisticsDetailButton];
//        [logisticsDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(WidthRate(-10));
//            make.height.mas_equalTo(HeightRate(30));
//            make.width.mas_equalTo(WidthRate(100));
//            make.top.mas_equalTo(line22.mas_bottom).offset(HeightRate(5));
//
//        }];
        
        YHButton *logisticsDetailButton = [YHButton initBorderStyleWithTitle:@"查看物流"];
        //        [logisticsDetailButton addTarget:self action:@selector(orderSlectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                self.logisticsDetailButton = logisticsDetailButton;
                [self addSubview:logisticsDetailButton];
                [logisticsDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(WidthRate(-10));
                    make.height.mas_equalTo(HeightRate(30));
                    make.width.mas_equalTo(WidthRate(100));
                    make.top.mas_equalTo(line22.mas_bottom).offset(HeightRate(5));
        
                }];
        
        
         self.commBtn = [YHButton initBorderStyleWithTitle:@"申请开票" color:StandardBlueColor cornerRadius:HeightRate(15)];
//        [paymentVoucher addTarget:self action:@selector(paymentVoucherClickedWithOrder) forControlEvents:UIControlEventTouchUpInside];
         self.commBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview: self.commBtn];
        [ self.commBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(logisticsDetailButton.mas_left).offset(WidthRate(-10));
            make.height.mas_equalTo(HeightRate(30));
            make.width.mas_equalTo(WidthRate(70));
            make.top.mas_equalTo(line22.mas_bottom).offset(HeightRate(5));
            
        }];
        
        
//        self.commBtn = paymentVoucher;
        
        YHButton *customerServiceButton = [YHButton initBorderStyleWithTitle:@"客服"  color:StandardBlueColor cornerRadius:HeightRate(15)];
        customerServiceButton.translatesAutoresizingMaskIntoConstraints = NO;
        [customerServiceButton setImage:[UIImage imageNamed:@"kufu3030"] forState:UIControlStateNormal];
        [customerServiceButton setImageEdgeInsets:UIEdgeInsetsMake(0, WidthRate(-5), 0, 0)];
        //        [customerServiceButton addTarget:self action:@selector(customerServiceButtonClickedWithOrder) forControlEvents:UIControlEventTouchUpInside]; dingdankefu
        [self addSubview:customerServiceButton];
        [customerServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo( self.commBtn.mas_left).offset(WidthRate(-10));
            make.height.mas_equalTo(HeightRate(30));
            make.width.mas_equalTo(WidthRate(70));
            make.top.mas_equalTo(line22.mas_bottom).offset(HeightRate(5));
            make.bottom.mas_equalTo(-10);

        }];
        self.customerServiceButton = customerServiceButton;
    }
    return self;
}

-(void)setData:(YHOrderContract *)contract withIsStore:(BOOL)isStore
{
    if (isStore ==YES || contract.InsuraceModel.InsurdAmount.floatValue<=0) {
        self.addInsuranceview.hidden = YES;
        [self.addInsuranceview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    if(![contract.OrderState isEqualToString:@"-2"])
    {
        self.payRateNameLabel.text = [NSString stringWithFormat:@" %.2f/%.2f",round([contract.HasPayFee doubleValue]*100)/100,round([contract.ContractAmount doubleValue]*100)/100];
        if (contract.ContractAmount.floatValue ==0) {
            [self.payRateBgLabel PSSetWidth:0];
        }else{
            CGFloat rate =contract.HasPayFee.floatValue/(contract.ContractAmount.floatValue);
            if (rate>1 ) {
                rate = 1;
            }else if(rate<0)
            {
                rate=0;
            }
            CGFloat labelWidth = WidthRate(240) * (rate);
            [self.payRateBgLabel PSUpdateConstraintsWidth:labelWidth];
        }
    }
    
    
//    if (contract.TaxPrice.doubleValue>0) {
//        self.tipsRightLable.textColor = [UIColor blackColor];
//        NSString *str = @"增值税";
//
//        NSString *priceStr =   [NSString stringWithFormat:@"%@:¥%@",str,[Tools getHaveNum:contract.TaxPrice.doubleValue]];//orders.GoodsAddValue
//
//        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:priceStr];
//        [att addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(SymbolTopColor) range:NSMakeRange(str.length+1, priceStr.length-str.length-1)];
//
//
//        self.tipsRightLableTop.attributedText = att;
//        [self.tipsRightLableTop mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(HeightRate(20));
//        }];
//        [self.tipsRightLable mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(HeightRate(0.01));
//        }];
//        self.tipsRightLable.hidden = YES;
//        self.tipsRightLableTop.hidden = false;
//
//    } else {
        self.tipsRightLableTop.hidden = YES;
        self.tipsRightLable.hidden = false;

        [self.tipsRightLableTop mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HeightRate(0.01));
        }];
        [self.tipsRightLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HeightRate(30));
        }];
        self.tipsRightLable.text = [NSString stringWithFormat:@"(%@)",contract.GoodsAddValue];
        
//    }
    _fixlable.text = [NSString stringWithFormat:@"共%@件商品  合计：",contract.ContractQuantity];
    _insureMoney.text = [NSString stringWithFormat:@"投保金额：¥%@",[Tools getHaveNum:contract.InsuraceModel.InsurdAmount.doubleValue]];
    _insureFee.text = [NSString stringWithFormat:@"人保保费0.5%%：¥%@",[Tools getHaveNum:(floorNumber(contract.InsuraceModel.InsurdAmount.doubleValue*0.005))]];
    _priceLable.text = [NSString stringWithFormat:@"¥%@",[Tools getHaveNum:contract.ContractAmount.doubleValue]];
    _tipsRightLable.text = [NSString stringWithFormat:@"%@",contract.GoodsAddValue];
  
    NSString *str =@"●付预付款 ———●生产中———●生产完成 ———●尾款";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
   
    
    switch (contract.OrderState.integerValue) {
        case -2:{//待签订
            [self.commBtn setTitle:@"合同洽谈" forState:UIControlStateNormal];
            self.commBtn.hidden = false;
            self.progressView.hidden = YES;
            [self.progressView PSUpdateConstraintsHeight:0.01];
            self.customerServiceButton.hidden = YES;

            self.logisticsDetailButton.hidden = YES;
            [self.logisticsDetailButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0.01);
                make.right.mas_equalTo(0);
            }];
            [self.stateLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0.01);
            }];
            self.stateLable.hidden = YES;
        }
            break;

        case 0:{//待付款
            [self.commBtn setTitle:@"付预付款" forState:UIControlStateNormal];
            self.logisticsDetailButton.hidden = YES;
            [self.logisticsDetailButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0.01);
                make.right.mas_equalTo(0);
            }];
            
            if ([contract.IsOut isEqualToString:@"0"]) {//已失效
                
                [self.commBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                self.logisticsDetailButton.hidden = YES;
                [self.logisticsDetailButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0.01);
                    make.right.mas_equalTo(0);
                }];
                
            }
            self.stateLable.hidden = false;
//            [attrStr addAttribute:NSForegroundColorAttributeName
//                            value:[UIColor redColor]
//                            range:NSMakeRange(0, 7)];
            
        }
            break;
        case 1:{//生产中
            [self.commBtn setTitle:@"付尾款" forState:UIControlStateNormal];
            self.logisticsDetailButton.hidden = YES;
            [self.logisticsDetailButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0.01);
                make.right.mas_equalTo(0);
            }];
            self.stateLable.hidden = false;
            [attrStr addAttribute:NSForegroundColorAttributeName
                                        value:ColorWithHexString(StandardBlueColor)
                                        range:NSMakeRange(0, 13)];
            self.stateLable.attributedText = attrStr;
            
        }
            break;

        case 2:{//已入库==生产完成
            
            [self.commBtn setTitle:@"付尾款" forState:UIControlStateNormal];
            self.logisticsDetailButton.hidden = YES;
            [self.logisticsDetailButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0.01);
                make.right.mas_equalTo(0);
            }];
            self.stateLable.hidden = false;
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:ColorWithHexString(StandardBlueColor)
                            range:NSMakeRange(0, 21)];
            self.stateLable.attributedText = attrStr;

        }
            break;
        case 3:{//已发货
            [self.commBtn setTitle:@"物流详情" forState:UIControlStateNormal];
            self.logisticsDetailButton.hidden = YES;
            [self.logisticsDetailButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0.01);
                make.right.mas_equalTo(0);
            }];
            self.stateLable.hidden = YES;
            [self.stateLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0.01);
            }];
        }
            break;
        default:{//-1
            
            [self.commBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            self.logisticsDetailButton.hidden = YES;
            [self.logisticsDetailButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0.01);
                make.right.mas_equalTo(0);
            }];
            self.stateLable.hidden = YES;
            [self.stateLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0.01);
            }];
        }
            break;
    }
            
   
    
}
-(id)progressView:(id)item rate:(CGFloat)rate name:(NSString *)name
{
    
    UIView *progressView = [[UIView alloc] init];
    progressView.translatesAutoresizingMaskIntoConstraints  = false;
    [self addSubview:progressView];
    [progressView PSSetBottomAtItem:item Length:HeightRate(0)];
    [progressView PSSetLeft:WidthRate(0)];
    [progressView PSSetSize:ScreenWidth Height:HeightRate(50)];
    self.progressView = progressView;
    
    YHLabel *paidMoneyLabel =  [[YHLabel alloc] initWithTextColor:BASE_FAINTLY_COLOR];
    paidMoneyLabel.text =name;
    paidMoneyLabel.translatesAutoresizingMaskIntoConstraints =NO;
    paidMoneyLabel.font =[UIFont systemFontOfSize:AdaptFont(paidFont)];
    [progressView addSubview:paidMoneyLabel];
//    [paidMoneyLabel PSSetTop:HeightRate(10)];
    [paidMoneyLabel PSSetLeft:WidthRate(18)];
    [paidMoneyLabel PSSetCenterHorizontalAtItem:progressView];
    
    self.paidMoneyLabel = paidMoneyLabel;
    
    UIView *broderView =  [[UIView alloc] init];
    broderView.translatesAutoresizingMaskIntoConstraints = NO;
    broderView.layer.borderWidth = 1;
    broderView.layer.cornerRadius = 3;
    broderView.layer.masksToBounds = YES;
    broderView.layer.borderColor =ColorWithHexString(BASE_LINE_COLOR).CGColor;
    [progressView addSubview:broderView];
    [broderView PSSetRightAtItem:paidMoneyLabel Length:WidthRate(3)];
    [broderView PSSetSize:WidthRate(240) Height:HeightRate(30)];
    
    YHLabel *appearslabel = [[YHLabel alloc]initWithTextColor:BASE_FAINTLY_COLOR];
    appearslabel.translatesAutoresizingMaskIntoConstraints   = NO;
    
    appearslabel.backgroundColor = [UIColor colorWithHexString:APP_THEME_MAIN_COLOR];
    [broderView addSubview:appearslabel];
    [appearslabel PSSetLeft:0];
    [appearslabel PSSetTop:0];
    [appearslabel PSSetWidth:0.01];
    [appearslabel PSSetHeight:HeightRate(30)];
//    [appearslabel PSSetCenterHorizontalAtItem:progressView];

    
    
    YHLabel *appearsTextlabel = [[YHLabel alloc]initWithTextColor:BASE_FAINTLY_COLOR];
    appearsTextlabel.translatesAutoresizingMaskIntoConstraints   = NO;
    appearsTextlabel.backgroundColor = [UIColor clearColor];
    appearsTextlabel.text =@"120万／200万";
    [broderView addSubview:appearsTextlabel];
    appearsTextlabel.font =[UIFont systemFontOfSize:AdaptFont(paidFont)];
    
    [appearsTextlabel PSSetConstraint:WidthRate(5) Right:0 Top:0 Bottom:0];
    

//    [broderView PSSetSize:WidthRate(240) Height:HeightRate(30)];

    self.payRateNameLabel = appearsTextlabel;
    self.payRateBgLabel =appearslabel;

    return progressView;
    
}
-(UILabel *)getHaveMoneyState:(UIView *)bgview bottomItem:(UILabel *)item name:(NSString *)name price:(NSString *)price state:(NSString *)state ispay:(BOOL)ispay
{
    UILabel *nameLable = [[UILabel alloc] init];
    nameLable.textColor = ColorWithHexString(@"1E1E1E") ;
    nameLable.text = [NSString stringWithFormat:@"%@",name];
    nameLable.font = [UIFont systemFontOfSize:AdaptFont(12)];
    //    nameLable.textAlignment = NSTextAlignmentRight;
    [bgview addSubview:nameLable];
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WidthRate(10));
        make.height.mas_equalTo(HeightRate(20));
        make.top.mas_equalTo(item.mas_bottom).offset(HeightRate(5));
        
    }];
    
    UILabel *priceLable = [[UILabel alloc] init];
    priceLable.textColor = ColorWithHexString(@"1E1E1E") ;
    priceLable.text = [NSString stringWithFormat:@"%@",price];
    priceLable.font = [UIFont systemFontOfSize:AdaptFont(12)];
    //    priceLable.textAlignment = NSTextAlignmentRight;
    [bgview addSubview:priceLable];
    [priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLable.mas_right).offset(WidthRate(0));
        make.height.mas_equalTo(HeightRate(20));
        make.top.mas_equalTo(item.mas_bottom).offset(HeightRate(5));
        
    }];
    
    UILabel *stateLable = [[UILabel alloc] init];
    
    stateLable.text = [NSString stringWithFormat:@"%@",state];
    stateLable.font = [UIFont systemFontOfSize:AdaptFont(12)];
    stateLable.textAlignment = NSTextAlignmentCenter;
    stateLable.layer.cornerRadius = 8;
    stateLable.clipsToBounds = YES;
    [bgview addSubview:stateLable];
    [stateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(WidthRate(-15));
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(53);
        make.top.mas_equalTo(item.mas_bottom).offset(HeightRate(5));
        
    }];
    
    if(ispay==YES)
    {
        stateLable.backgroundColor = ColorWithHexString(SymbolTopColor) ;
        stateLable.textColor = ColorWithHexString(@"ffffff") ;
        
        
    }else
    {
        stateLable.backgroundColor = ColorWithHexString(@"F2F2F2") ;
        stateLable.textColor = ColorWithHexString(@"999999") ;
        
    }
    
    return nameLable;
    
}

@end