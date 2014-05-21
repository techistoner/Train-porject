//
//  webviewViewController.m
//  Train-special
//
//  Created by GST_MAC02 on 14-1-21.
//  Copyright (c) 2014年 GST_MAC02. All rights reserved.
//

#import "webviewViewController.h"
#import "DEMONavigationController.h"
@interface webviewViewController ()

@end

@implementation webviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.flagVC==1) {
        self.title = @"订单查询";
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"menu.png"]
                          forState:UIControlStateNormal];
        [button addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 30, 30);
        
        UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        self.navigationItem.leftBarButtonItem = left ;
        
    }
    else
    {
        self.title = @"车票购买";
        
    }
    [self.webview setScalesPageToFit:YES];
    NSString *string= self.urlString;
    NSURL *url= [[NSURL alloc]initWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [self.webview loadRequest:request];
    
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    self.hud.dimBackground = NO;

}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.hud.labelText = @"正在加载";
    [self.webview addSubview:self.hud];
    [self.hud show:YES];
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    [self removembp];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    self.hud.labelText = @"网络连接失败，请重试";
    [self.webview addSubview:self.hud];
    [self.hud show:YES];
    [self performSelector:@selector(removembp) withObject:nil afterDelay:1];
    
}

-(void)removembp
{
        [self.hud removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
