//
//  YHTitleView.h
//  TitleSelectView
//
//  Created by 谷伟 on 2017/10/16.
//  Copyright © 2017年 谷伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHTitleViewDelegate.h"
@interface YHTitleView : UIView

@property (nonatomic, weak)UIViewController<YHTitleViewViewDelegete>* delegate;

@property(nonatomic,strong)NSMutableArray * titleButtonArray;
- (instancetype)initWithFrame:(CGRect)rect titleFont:(NSInteger)size delegate:(id)delegate andTitleArray:(NSArray *)titleArray;

- (void)selectItemWithIndex:(NSInteger)index;

- (void)ChageItemWithIndex:(NSInteger)index;

@end
