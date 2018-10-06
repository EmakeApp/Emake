//
//  YHMainSearchViewController.m
//  emake
//
//  Created by 张士超 on 2018/6/4.
//  Copyright © 2018年 emake. All rights reserved.
//

#import "YHMainSearchViewController.h"
#import "YHMainSearchTableViewCell.h"
#import "YhSearchModel.h"
#import "YHProductDetailsViewController.h"
#import "YHMainSearchKeyWordsTableViewCell.h"

@interface YHMainSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,YHSearchKeywordSDelegate>{
    NSInteger  numberSection;
    NSString *  searchStr;
    NSString *  searchkey;//保存在本地的key值
    BOOL   isNotSearch;

}
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)UIButton *cancleBtn;
@property(nonatomic,strong)NSArray *searchResultArr;
@property(nonatomic,strong)NSArray *searchKeywordsArr;

@property(nonatomic,strong)UIView *EmptyView;

@end

@implementation YHMainSearchViewController

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if (!_searchBar.isFirstResponder) {
        [self.searchBar becomeFirstResponder];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TextColor_F5F5F5;
    NSString *iphone = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_MOBILEPHONE];
    searchkey = [NSString stringWithFormat:@"%@%@" ,iphone,USERSSearchKeywords];
 
    CGFloat tableHeight =TOP_BAR_HEIGHT;
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT, ScreenWidth,  ScreenHeight-tableHeight) style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    [self.view addSubview:myTableView];
    self.myTableView = myTableView;
    numberSection = 2;

    [self setBarButtonItem];
    [self getSearcgKeywordsData];
}

#pragma mark--搜索接口
-(void)searchData:(NSString *)str
{
    self.searchResultArr = [NSArray array];
    [[YHJsonRequest shared] userSearchProductWithParameter:str SuccessBlock:^(NSArray *Success) {
        [self.EmptyView removeFromSuperview];

//       搜索后的内容在保存到本地且只保存最近10条
        NSArray *strArr = [[NSUserDefaults standardUserDefaults] objectForKey:searchkey];
        NSMutableArray * strMArr = [NSMutableArray arrayWithArray:strArr];
        [strMArr insertObject:str atIndex:0];
        if (strMArr.count>10) {
            [strMArr removeLastObject];
        }
        [[NSUserDefaults standardUserDefaults] setObject:strMArr forKey:searchkey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.searchResultArr = Success;
       
        [self.myTableView reloadData];
        if (Success.count ==   0) {
            [self configEmptyView];
        }
    } fialureBlock:^(NSString *errorMessages) {
        [self.myTableView reloadData];
        [self.view makeToast:errorMessages duration:1. position:CSToastPositionCenter];
    }];
}
//热搜商品
-(void)getSearcgKeywordsData
{
    [[YHJsonRequest shared] userSearchKeyWordsSuccessBlock:^(NSArray *Success) {
        self.searchKeywordsArr = [NSArray arrayWithArray:Success];
        [self.myTableView reloadData];
        
    } fialureBlock:^(NSString *errorMessages) {
        [self.myTableView reloadData];

        [self.view makeToast:errorMessages duration:1.5 position:CSToastPositionCenter];
        
    }];
}
#pragma mark--搜索UI
- (void)setBarButtonItem
{
    //隐藏导航栏上的返回按钮
    [self.navigationItem setHidesBackButton:YES];
    //用来放searchBar的View
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(15, 7, ScreenWidth-60, 30)];
    //创建searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleView.frame) - 15, 30)];
    //默认提示文字
    searchBar.placeholder = @"请输入搜索内容";
    //背景图片
    searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
    //代理
    searchBar.delegate = self;
    //显示右侧取消按钮
    searchBar.showsCancelButton = YES;
    //光标颜色
    searchBar.tintColor = ColorWithHexString(@"666666");
    //拿到searchBar的输入框
    UITextField *searchTextField = [searchBar valueForKey:@"_searchField"];
    //字体大小
    searchTextField.font = [UIFont systemFontOfSize:13];
    //输入框背景颜色
    searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
    //拿到取消按钮
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
    //设置按钮上的文字
//    [cancleBtn setTitle:@"搜索" forState:UIControlStateNormal];
    //设置按钮上文字的颜色
//    [cancleBtn setTitleColor:ColorWithHexString(@"666666") forState:UIControlStateNormal];
    cancleBtn.hidden  = YES;
    self.cancleBtn = [[UIButton alloc] init];
    CGFloat width = cancleBtn.bounds.size.width;
    CGFloat height = cancleBtn.bounds.size.height;
    CGFloat x = titleView.bounds.size.width - width-WidthRate(20);

    self.cancleBtn.frame = CGRectMake(x, 0, width, height);
    [self.cancleBtn setTitle:@"搜索" forState:UIControlStateNormal];
    //设置按钮上文字的颜色
    [self.cancleBtn setTitleColor:ColorWithHexString(@"666666") forState:UIControlStateNormal];
    self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:AdaptFont(13)];
    [self.cancleBtn addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn.superview addSubview:self.cancleBtn];

//    self.cancleBtn = cancleBtn;

    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
    self.navigationItem.titleView = titleView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(numberSection == 1)
    {
        return self.searchResultArr.count;
    }else
    {
        if (section==1) {
            
            NSArray *strArr = [[NSUserDefaults standardUserDefaults] objectForKey:searchkey];
          
            return strArr.count;
        }
        return 1;
    }}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return numberSection;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(numberSection == 1)
    {
        return UITableViewAutomaticDimension;
    }else
    {
        if (indexPath.section == 0) {
            CGFloat TotalWidth =0;
            CGFloat Totalheight = 0;

            for (NSInteger i = 0; i < self.searchKeywordsArr.count; i++) {
                NSString *str = self.searchKeywordsArr[i];
                CGRect rect = [str boundingRectWithSize:CGSizeMake(WidthRate(300), 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:AdaptFont(11)]} context:nil];
                
                CGFloat w = rect.size.width+30;
                CGFloat h = 40;
                
                TotalWidth += w+10;
                int yy = (int)(WidthRate(TotalWidth)/(ScreenWidth-30));
               Totalheight = (yy+1)*h +10;
                NSLog(@"Totalwidth=%f,yy=%d,Totalheight=%f",TotalWidth,yy,Totalheight);


            }
            return HeightRate(Totalheight);
        }
        
    return HeightRate(41);
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (numberSection == 1) {
        YhSearchModel *model = self.searchResultArr[indexPath.row];
        YHMainSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell==nil) {
            cell = [[YHMainSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
//        cell.productImage.image = [UIImage imageNamed:@"placehold"];
        [cell.productImage sd_setImageWithURL:[NSURL URLWithString: model.GoodsSeriesIcon]];

        cell.productName.text = model.GoodsSeriesName;
        cell.productPrice.text =[NSString stringWithFormat:@"%@",model.PriceRange];
        
        return cell;
    }else if(indexPath.section == 1)
    {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *strArr = [[NSUserDefaults standardUserDefaults] objectForKey:searchkey];
    cell.textLabel.text  = strArr[indexPath.row];
            
        
    cell.textLabel.textColor = ColorWithHexString(@"666666");
    cell.textLabel.font = [UIFont systemFontOfSize:AdaptFont(13)];
    
    
    return cell;
        
    }else
    {
        YHMainSearchKeyWordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell22"];
        if (cell==nil) {
            cell = [[YHMainSearchKeyWordsTableViewCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.searchkeywordsDelegate = self;
        [cell setData:self.searchKeywordsArr];
        
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (numberSection == 1) {
        return 0.001;
    }
    return HeightRate(41);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height ;
    if (numberSection == 1) {
        height = 0.01;
    }else
    {
        height = 41;

    }
 
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HeightRate(height))];
    bgview.backgroundColor = ColorWithHexString(@"ffffff");
    
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WidthRate(120), HeightRate(height))];
    nameLable.textColor = [UIColor blackColor];
    nameLable.font = [UIFont systemFontOfSize:AdaptFont(13)];
//    nameLable.backgroundColor = ColorWithHexString(@"ffffff");
    [bgview addSubview:nameLable];
    switch (section) {
        case 0:
            {
                if (numberSection == 1) {
                    nameLable.hidden = YES;

                }else
                {
                nameLable.hidden = false;
                nameLable.text = @"    热门搜索";
                }
                
            }
            break;
        case 1:
        {
            nameLable.hidden = false;
            nameLable.text = @"     最近搜索";
//            nameLable.userInteractionEnabled = YES;
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            deleteBtn.frame = CGRectMake(WidthRate(160), 30, 34, 41);
            [deleteBtn setImage:[UIImage imageNamed:@"lajitong"] forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(deleteSearchData) forControlEvents:UIControlEventTouchUpInside];
            [bgview addSubview:deleteBtn];
            [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(nameLable.mas_centerY).offset(0);
                make.right.mas_equalTo(WidthRate(-15));
                make.width.mas_equalTo(WidthRate(35));
                make.height.mas_equalTo(HeightRate(35));

            }];
            
        }
            break;
       
        default:
            break;
    }
    
    
    return bgview;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (numberSection == 1) {
        YhSearchModel *model = self.searchResultArr[indexPath.row];
        YHProductDetailsViewController *detaiVC = [[YHProductDetailsViewController alloc] init];
        detaiVC.GoodsSeriesCode = model.GoodsSeriesCode;
        detaiVC.productSerialCode = model.GoodsSeriesCode;
        detaiVC.StoreName = model.StoreName;
        detaiVC.storeAvata = model.StorePhoto;
        detaiVC.StoreID = model.StoreId;
        detaiVC.storePhoneNumber = model.StoreNum;
        [self.navigationController pushViewController:detaiVC animated:YES];
    }else{
        if (indexPath.section == 1) {
            
        numberSection = 1;
        NSArray *strArr = [[NSUserDefaults standardUserDefaults] objectForKey:searchkey];
        [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        searchStr = strArr[indexPath.row];
        self.searchBar.text = strArr[indexPath.row];
        [self searchData:searchStr];
        [tableView reloadData];
            
        }
    }
}

#pragma mark searchButton
-(void)searchButtonClick:(UIButton *)button
{
    if(numberSection == 1)
    {
        numberSection = 2;
        [button setTitle:@"搜索" forState:UIControlStateNormal];
        [self.searchBar resignFirstResponder];
        [self.EmptyView removeFromSuperview];
        searchStr = @"";
        self.searchBar.text = @"";
        
    }else if(numberSection == 2)
    {
        if (searchStr.length<=0) {
            isNotSearch = YES;

            [self.view makeToast:@"搜索内容不能为空" duration:1.5 position:CSToastPositionCenter];
        }else
        {
            numberSection = 1;

            [self searchData:searchStr];
             [button setTitle:@"取消" forState:UIControlStateNormal];
        }
        
       
        [self.searchBar resignFirstResponder];
      
    }
    
    [self.myTableView reloadData];
}
-(void)deleteSearchData
{
    //       搜索后的内容在保存到本地且只保存最近10条
 
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:searchkey];
    [self.myTableView reloadData];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isNotSearch = YES;
    [self.searchBar resignFirstResponder];

}

- (void)configEmptyView{
    self.EmptyView = [[UIView alloc]init];
    self.EmptyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.EmptyView];
    
    [self.EmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo((TOP_BAR_HEIGHT));
        make.bottom.mas_equalTo(0);
    }];
    
    
    UIImageView *emptyImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queyimianpeitu"]];
    self.EmptyView.contentMode = UIViewContentModeScaleAspectFit;
    [self.EmptyView addSubview:emptyImage];
    
    [emptyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.EmptyView.mas_centerX);
        make.top.mas_equalTo(HeightRate(160));
        make.width.mas_equalTo(WidthRate(200));
        make.height.mas_equalTo(WidthRate(200));
    }];
    
    UILabel *labelText = [[UILabel alloc]init];
    labelText.text = @"没有找到相关产品";
    labelText.textAlignment = NSTextAlignmentCenter;
    labelText.font = SYSTEM_FONT(AdaptFont(16));
    [self.EmptyView addSubview:labelText];
    
    
    [labelText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.EmptyView.mas_centerX);
        make.top.mas_equalTo(emptyImage.mas_bottom).offset(HeightRate(10));
        
    }];
}
#pragma mark - UISearchBarDelegate
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//   
////   [self.searchBar becomeFirstResponder];
//
//    return YES;
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if (searchStr.length<=0) {
        [self.view makeToast:@"搜索内容不能为空" duration:1.5 position:CSToastPositionCenter];
    }else
    {
        [self searchData:searchStr];
         numberSection = 1;
        [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];

    }
   
    [self.searchBar resignFirstResponder];
    [self.myTableView reloadData];
//    searchStr = @"";
//    searchBar.text = @"";
    NSLog(@"SearchButton");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (isNotSearch == false) {
        if (numberSection ==  1)
        {
            [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }

}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchStr = searchText;
}
#pragma mark--searchkeywordsDelegate
-(void)YhsearchKeyWords:(UIView *)item index:(NSInteger)index
{
    numberSection = 1;
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    NSString *str = self.searchKeywordsArr[index];
    self.searchBar.text = str;
    searchStr = str;
    [self.searchBar resignFirstResponder];
    [self searchData:str];
    
    
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