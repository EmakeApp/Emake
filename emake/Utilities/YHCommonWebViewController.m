//
//  YHCommonWebViewController.m
//  emake
//
//  Created by 谷伟 on 2017/12/12.
//  Copyright © 2017年 emake. All rights reserved.
//

#import "YHCommonWebViewController.h"
#import <WebKit/WebKit.h>
@interface YHCommonWebViewController ()
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, retain) WKWebView *webView;
@property (nonatomic, retain) UIWebView *htmlWebView;

@end

@implementation YHCommonWebViewController
- (WKWebView *)webView{
    if (!_webView) {
        WKWebView *wk =  [[WKWebView alloc] init];
        wk.scrollView.showsHorizontalScrollIndicator = false;
        wk.scrollView.alwaysBounceVertical = YES;
     
             NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
            [wk loadRequest:urlRequest ];

        
       
        self.webView = wk;
    }
    return _webView;
}
-(UIWebView *)htmlWebView{
    if (!_htmlWebView) {
        UIWebView *web =  [[UIWebView alloc] init];
        web.scalesPageToFit = YES;
        [web sizeToFit];
        [web loadHTMLString:self.URLString baseURL:nil];
        [self.view addSubview: web];
        [ web mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(TOP_BAR_HEIGHT);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        self.htmlWebView = web;
    }
    return _htmlWebView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.titleName;
    if (self.isShare == YES) {
        [self addRigthDetailButtonIsShowShare:YES];

    }else
    {
    [self addRigthDetailButtonIsShowCart:false];
    }
    [self configUI];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [Tools cleanCacheAndCookie];
}
- (void)configUI {
    
    if (self.isLoadHTMLStr == YES) {
        self.htmlWebView.scrollView.showsHorizontalScrollIndicator = false;
        self.htmlWebView.scrollView.alwaysBounceVertical = YES;
        
    }else{
        
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self.view addSubview:_webView];
        
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(TOP_BAR_HEIGHT);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [self configWebViewProgress];

    }
    
}
- (void)configWebViewProgress {
    
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - 2.0f, navigationBarBounds.size.width, 2.0);
    _progressView = [[UIProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.navigationController.navigationBar addSubview:self.progressView];

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}
- (void)dealloc{
    if (self.isLoadHTMLStr == false) {
        [self.progressView removeFromSuperview ];
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
  
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