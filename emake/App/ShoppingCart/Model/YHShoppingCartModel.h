//
//  YHShoppingCartModel.h
//  emake
//
//  Created by eMake on 2017/8/21.
//  Copyright © 2017年 emake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHShoppingCartModel : NSObject

@property(nonatomic,copy)NSString *CategoryId;
@property(nonatomic,copy)NSString *GoodsAddValue;
@property(nonatomic,copy)NSString *GoodsExplain;
@property(nonatomic,copy)NSString *GoodsNumber;
@property(nonatomic,copy)NSString *GoodsSeriesCode;
@property(nonatomic,copy)NSString *GoodsSeriesIcon;
@property(nonatomic,copy)NSString *GoodsTitle;
@property(nonatomic,copy)NSString *IsInvoice;
@property(nonatomic,copy)NSString *MainProductPrice;
@property(nonatomic,copy)NSString *OrderNo;
@property(nonatomic,copy)NSString *ProductGroupPrice;
@property(nonatomic,copy)NSArray *AddServiceInfo;
@property(nonatomic,copy)NSString *MainMakePrice;

@property(nonatomic,copy)NSString *StoreId;
@property(nonatomic,copy)NSString *StoreName;
@property(nonatomic,copy)NSString *StorePhoto;

@property(nonatomic,assign)BOOL isSelectInsurance;
@property(nonatomic,copy) NSString *InsuranceMoney;
@property(nonatomic,copy) NSString *InsuranceNewMoney;
@property(nonatomic,copy) NSString *IsPriceTax;//
@property(nonatomic,copy) NSString *SuperGroupDetailId;//
@property(nonatomic,copy) NSString *CategoryBId;//

//
@property(nonatomic,strong)NSString *storeTotalPrice;
//
//
@property(nonatomic,assign)NSInteger storeTotalNumber;
@property(nonatomic,assign)BOOL isShowInsranceView;

//
//@property(nonatomic,copy)NSString *GoodsSeriesCode;//SCBH15-315-010-60
@property(nonatomic,copy)NSString *GoodsSeriesPhotos;
//
//@property(nonatomic,copy)NSString *MainPrice;
//
//@property(nonatomic,strong)NSString *GoodsImage;
//@property(nonatomic,copy)NSString *GoodsSeriesName;
//@property(nonatomic,copy)NSString *GoodsSeriesImageUrl;
//@property(nonatomic,strong)NSString *GoodsPrice;
//@property(nonatomic,strong)NSNumber *MaterialFee;
//@property(nonatomic,strong)NSNumber *ProductionFee;
//@property(nonatomic,copy)NSString *GoodsSize;
//@property(nonatomic,copy)NSString *GoodsWeight;
//@property(nonatomic,copy)NSString *GoodsName;
//
//@property(nonatomic,copy)NSString *AuxiliaryName;
//@property(nonatomic,copy)NSNumber *AuxiliaryCode;
//@property(nonatomic,copy)NSString *BrandName;
//@property(nonatomic,copy)NSString *BrandCode;
//@property(nonatomic,copy)NSArray *add_service;
@property (nonatomic,assign)BOOL isSelect;
@property (nonatomic,assign)BOOL isSectionSelect;
@property (nonatomic,assign)BOOL isEdit;
@property (nonatomic,assign)BOOL isEditNumber;

@property(nonatomic,copy)NSString *GoodsTaxRate;

//@property(nonatomic,copy)NSString *CategoryId;
@property(nonatomic,copy)NSString *GoodsSeriesCode2;

@property(nonatomic,copy)NSString *totalPrice;
@property(nonatomic,assign)int totalNumber;

@property(nonatomic,copy)NSArray *AddServiceArr;

@property (nonatomic, copy) NSString *AddSeriesName;

@end
