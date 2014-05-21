//
//  AboutViewController.m
//  Train-special
//
//  Created by GST_MAC02 on 14-1-23.
//  Copyright (c) 2014年 GST_MAC02. All rights reserved.
//

#import "AboutViewController.h"
#import "DEMONavigationController.h"
#import "ASIHTTPRequest.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关于我们";
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"menu.png"]
                          forState:UIControlStateNormal];
        [button addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 30, 30);
        
        UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        self.navigationItem.leftBarButtonItem = left ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tbutton addTarget:self action:@selector(goT) forControlEvents:UIControlEventTouchUpInside];
    [self.sbutton addTarget:self action:@selector(goS) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setProgress:(float)newProgress
{
    NSLog(@"%f",newProgress);
}
- (void)requestStarted:(ASIHTTPRequest *)request
{ 
    NSLog(@"start");
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"fin");

}
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    NSLog(@"%lld",bytes);
}
-(void)goT
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://techistoner@qq.com"]];
}

-(void)goS
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://sui.t@163.com"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end