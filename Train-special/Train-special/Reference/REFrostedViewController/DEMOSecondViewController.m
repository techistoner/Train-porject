//
//  DEMOSecondViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOSecondViewController.h"
#import "DEMONavigationController.h"
#import "AppDelegate.h"
#import "TrianTimeViewController.h"
#import "StSViewController.h"
@interface DEMOSecondViewController ()
{
    NSMutableArray *collectArray;
}
@end

@implementation DEMOSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    switch (self.Vcflag) {
        case 0:
            self.title = @"收藏夹";
            break;
        case 1:
            self.title = @"历史记录";
            break;
            
        default:
            break;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"menu.png"]
                      forState:UIControlStateNormal];
    [button addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = left ;

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单"
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:(DEMONavigationController *)self.navigationController
//                                                                            action:@selector(showMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(tableviewintoEdit)];
    
    
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 118, 320, [[UIScreen mainScreen] applicationFrame].size.height-118) style:UITableViewStylePlain];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    [self.view addSubview:self.table];
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    self.hud.labelText = @"正在查询";
    self.hud.dimBackground = NO;
    [self.train setTag:0];
    [self.station setTag:1];
    [self.train addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
     [self.station addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.flag = 0;//用来切换数据源
    [super viewDidLoad];
    switch (self.Vcflag) {
        case 0:
       collectArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"t"]];
            break;
        case 1:
        collectArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"tHistory"]];
            break;
        default:
            break;
    }

 
    NSLog(@"%@",collectArray);
    
}


- (void)viewWillAppear:(BOOL)animated

{
    
    [super viewWillAppear:animated];
    [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:YES];
    
    
}
-(void)changeBtn:(UIButton *)sender
{
  
    if (sender.tag==0) {
        self.flag = 0;
        switch (self.Vcflag) {
            case 0:
                collectArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"t"]];
                break;
            case 1:
                collectArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"tHistory"]];
                break;
            default:
                break;
        }
    }
    else
    {
        self.flag = 1;
        switch (self.Vcflag) {
            case 0:
                collectArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"s"]];
                break;
            case 1:
                collectArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"sHistory"]];
                break;
            default:
                break;
        }

    }
    NSLog(@"%@",collectArray);

    [self.table reloadData];

}

#pragma mark tableview


-(void)tableviewintoEdit
{
    [self.table setEditing:YES animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(tableviewbackEdit)];
    

}

-(void)tableviewbackEdit
{
    [self.table setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(tableviewintoEdit)];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView setEditing:NO animated:YES];

    return  UITableViewCellEditingStyleDelete;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView setEditing:NO animated:YES];
    [collectArray removeObjectAtIndex:indexPath.row];
    
    if (self.flag == 0) {
        switch (self.Vcflag) {
            case 0:
                [[NSUserDefaults standardUserDefaults]setObject:collectArray forKey:@"t"];
                break;
            case 1:
                [[NSUserDefaults standardUserDefaults]setObject:collectArray forKey:@"tHistory"];

                break;
            default:
                break;
        }
    }
    else
    {
        switch (self.Vcflag) {
            case 0:
                [[NSUserDefaults standardUserDefaults]setObject:collectArray forKey:@"s"];
                break;
            case 1:
                [[NSUserDefaults standardUserDefaults]setObject:collectArray forKey:@"sHistory"];
                
                break;
            default:
                break;
        }
    }
    [self.table reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [collectArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"StationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                         SimpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",[collectArray objectAtIndex:indexPath.row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url = nil;
    if (self.flag==0) {
        url = [NSString stringWithFormat:@"http://apis.juhe.cn/train/s?name=%@&key=%@",[[NSString stringWithFormat:@"%@",[collectArray objectAtIndex:indexPath.row]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],APPKEY];
    }
    else
    {
        NSString *string = [NSString stringWithFormat:@"%@",[collectArray objectAtIndex:indexPath.row]];
        NSRange range = [string rangeOfString:@"-"];
        self.start = [string substringWithRange:NSMakeRange(0, range.location)];
        self.end = [string substringWithRange:NSMakeRange(range.location+1, string.length-range.location-1)];
        url = [NSString stringWithFormat:@"http://apis.juhe.cn/train/s2s?start=%@&end=%@&key=%@",[self.start stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.end stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],APPKEY];
    }
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];

    if (self.flag==0) {
        [request setTag:0];
    }
    else
    {
         [request setTag:1];
    }
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request startAsynchronous];
    
    
    
}
- (void)requestStarted:(ASIHTTPRequest *)request
{
    
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    NSLog(@"******");
    
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    [self.hud removeFromSuperview];
    [self.hud show:NO];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];
    NSString *stataCode = [dic objectForKey:@"resultcode"];
    switch ([stataCode intValue]) {
        case 200:
        {
            if (request.tag==0) {
                
                TrianTimeViewController *train = [[TrianTimeViewController alloc]initWithNibName:@"TrianTimeViewController" bundle:nil];
                train.dictonary = dic;
                switch (self.Vcflag) {
                    case 0:
                        train.collectFlag = 1;
                        break;
                        
                    default:
                        break;
                }
                [self.navigationController pushViewController:train animated:YES];
            }
            else if (request.tag==1)
            {
                
                NSLog(@"******%@",dic);
                StSViewController *stsVC = [[StSViewController alloc]initWithNibName:@"StSViewController" bundle:nil];
                stsVC.stsDic = dic;
                stsVC.startString = self.start;
                stsVC.endString = self.end;
                switch (self.Vcflag) {
                    case 0:
                        stsVC.collectFlag = 1;
                        break;
                        
                    default:
                        break;
                }
                [self.navigationController pushViewController:stsVC animated:YES];
            }

        }
            
            break;
        case 201:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"列次名称不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case 202:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"查询不到结果" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self.hud show:NO];
    [self.hud removeFromSuperview];

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络错误，请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
