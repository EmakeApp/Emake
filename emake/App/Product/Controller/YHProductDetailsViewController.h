//
//  YHProductDetailsViewController.h
//  emake
//
//  Created by 谷伟 on 2017/11/28.
//  Copyright © 2017年 emake. All rights reserved.
//

#import "PSVCBase.h"

@interface YHProductDetailsViewController : PSVCBase
//fenxiang
@property (nonatomic, copy) shareBlock shareblock;
@property(nonatomic,copy) NSString *productSerialCode;
@property(nonatomic,copy)NSString *productCode;
@property(nonatomic,copy)NSString *GoodsSeriesCode;
@property(nonatomic,copy)NSString *StoreID;
@property(nonatomic,copy)NSString *StoreName;
@property(nonatomic,copy)NSString *storeAvata;
@property(nonatomic,copy)NSString *storePhoneNumber;
@property(nonatomic,copy)NSString *SuperGroupDetailId;
@property(nonatomic,copy)NSString *CouponNumberStr;

@property(nonatomic,assign)BOOL isChat;

@end
