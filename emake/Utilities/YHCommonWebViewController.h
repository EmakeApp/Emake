//
//  YHCommonWebViewController.h
//  emake
//
//  Created by 谷伟 on 2017/12/12.
//  Copyright © 2017年 emake. All rights reserved.
//

#import "PSVCBase.h"
@interface YHCommonWebViewController : PSVCBase
@property (nonatomic,retain)NSString *titleName;
@property (nonatomic,assign)enum WebType time;
@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, assign) BOOL isLoadHTMLStr;
@property (nonatomic, assign) BOOL isShare;

@end
