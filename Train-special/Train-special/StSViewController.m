//
//  StSViewController.m
//  Train-special
//
//  Created by GST_MAC02 on 14-1-16.
//  Copyright (c) 2014年 GST_MAC02. All rights reserved.
//

#import "StSViewController.h"
#import "StationCell.h"
#import "TrianTimeViewController.h"
#import "AppDelegate.h"


#define kDuration 0.3


#import "webviewViewController.h"

@interface StSViewController ()
{
    NSArray *stationArray;
    NSArray *typeArray;
    UIButton *rightbutton;
}

@end

@implementation StSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"站站查询";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDictionary *dic = [self.stsDic objectForKey:@"result"];
    [self.total setText:[NSString stringWithFormat:@"共%@条线路",[dic objectForKey:@"totalcount"]]];
    [self.start setText:self.startString];
    [self.end setText:self.endString];
    stationArray = [dic objectForKey:@"data"];
    typeArray = [NSArray arrayWithObjects:@"全部",@"G-高速动车",@"K-快速",@"T-空调特快",@"D-动车组",@"Z-直达特快",@"Q-其他",nil];
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 145, 320, [[UIScreen mainScreen] applicationFrame].size.height-145) style:UITableViewStylePlain];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    [self.view addSubview:self.table];
    
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    self.hud.labelText = @"正在查询";
    self.hud.dimBackground = NO;
//    if (!self.collectFlag==1) {
    
    if ([self isCollected]) {
        rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightbutton setBackgroundImage:[UIImage imageNamed:@"collected.png"]forState:UIControlStateNormal];
    }else{
        rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightbutton setBackgroundImage:[UIImage imageNamed:@"collection.png"]forState:UIControlStateNormal];
        
    }
    
    
    [rightbutton addTarget:self action:@selector(collection)
          forControlEvents:UIControlEventTouchUpInside];
    rightbutton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = right;


//    }
    
    //
    [self.toolright setTarget:self];
    [self.tooleft setTarget:self];
    [self.tooleft setAction:@selector(cancelSelect:)];
    [self.toolright setAction:@selector(selectTrainType:)];

    
    
    
    
}
- (void)viewWillAppear:(BOOL)animated

{
    
    [super viewWillAppear:animated];
    [self.table deselectRowAtIndexPath:self.table.indexPathForSelectedRow animated:YES];
    
    
    
}


-(BOOL)isCollected{
    appdelegate;
    NSString *string = [NSString stringWithFormat:@"%@-%@",self.start.text,self.end.text];
    NSLog(@"trainCollection%@",del.stationCollection);
    if (![del.stationCollection count]==0) {
        BOOL is_Exist= NO;
        for (int i =0 ; i<[del.stationCollection count]; i++) {
            NSString *juge = [NSString stringWithFormat:@"%@",[del.stationCollection objectAtIndex:i]];
            if ([string isEqualToString:juge]) {
                is_Exist = YES;
                break;
            }
            else
            {
                is_Exist= NO;
            }
        }
        return is_Exist;
    }
    else{
        return NO;
    }

}

-(void)collection
{
    NSString *string = [NSString stringWithFormat:@"%@-%@",self.start.text,self.end.text];
    appdelegate;
    NSLog(@"%@",del.stationCollection);
    NSLog(@"%@",string);
    
    if ([del.stationCollection count]==0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"收藏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [del.stationCollection addObject:string];
        [[NSUserDefaults standardUserDefaults]setObject:del.stationCollection forKey:@"s"];
        [rightbutton setBackgroundImage:[UIImage imageNamed:@"collected.png"]forState:UIControlStateNormal];

    }
    else
    {
        BOOL is_Exist= NO;
        for (int i =0 ; i<[del.stationCollection count]; i++) {
            NSString *juge = [NSString stringWithFormat:@"%@",[del.stationCollection objectAtIndex:i]];
            if ([string isEqualToString:juge]) {
                is_Exist = YES;
                break;
            }
            else
            {
              is_Exist= NO;
            }
        }
        if (is_Exist) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"已经收藏过" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"收藏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [del.stationCollection addObject:string];
            [[NSUserDefaults standardUserDefaults]setObject:del.stationCollection forKey:@"s"];
        }
    }
    
}
-(void)refrashData:(id)type
{
    [self.chooseView removeFromSuperview];

    NSString *url = nil;
    NSLog(@"%@",type);
    if ([type isKindOfClass:[UIBarButtonItem class]]) {
        if (self.typeString==nil) {
            url = [NSString stringWithFormat:@"http://apis.juhe.cn/train/s2s?start=%@&end=%@&key=%@",[self.start.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.end.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],APPKEY];
        }
        else
        {
            NSString *string =  self.typeString;
            url = [NSString stringWithFormat:@"http://apis.juhe.cn/train/s2s?start=%@&end=%@&traintype=%@&key=%@",[self.start.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.end.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[string substringWithRange:NSMakeRange(0, 1)],APPKEY];
        }
    }
    else if ([type isKindOfClass:[NSString class]])
    {
        if (self.typeString==nil) {
            url = [NSString stringWithFormat:@"http://apis.juhe.cn/train/s2s?start=%@&end=%@&key=%@",[self.start.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.end.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],APPKEY];
        }
        else
        {
            NSString *string =  self.typeString;
            url = [NSString stringWithFormat:@"http://apis.juhe.cn/train/s2s?start=%@&end=%@&traintype=%@&key=%@",[self.start.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.end.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[string substringWithRange:NSMakeRange(0, 1)],APPKEY];
        }

    }
    else if ([type isKindOfClass:[UIButton class]])
    {
        if (self.typeString==nil) {
            url = [NSString stringWithFormat:@"http://apis.juhe.cn/train/s2s?start=%@&end=%@&key=%@",[self.start.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.end.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],APPKEY];
        }
        else
        {
            NSString *string =  self.typeString;
            url = [NSString stringWithFormat:@"http://apis.juhe.cn/train/s2s?start=%@&end=%@&traintype=%@&key=%@",[self.start.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.end.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[string substringWithRange:NSMakeRange(0, 1)],APPKEY];
        }

    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTag:0];
    [request startAsynchronous];

    
}

#pragma mark tableview

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [stationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"StationCell";
    StationCell *cell = [tableView dequeueReusableCellWithIdentifier:
                  SimpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"StationCell" owner:self options:nil];
        cell = nib[0];
    }
    NSDictionary *dic = [stationArray objectAtIndex:indexPath.row];
    [cell.trainOpp setText:[NSString stringWithFormat:@"%@(%@)",[dic objectForKey:@"trainOpp"],[dic objectForKey:@"train_typename"]]];
    [cell.arrived_time setText:[NSString stringWithFormat:@"到时：%@",[dic objectForKey:@"arrived_time"]]];
    [cell.leave_time setText:[NSString stringWithFormat:@"开时：%@",[dic objectForKey:@"leave_time"]]];
    [cell.mileage setText:[NSString stringWithFormat:@"%@公里",[dic objectForKey:@"mileage"]]];
    [cell.start_staion setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"start_staion"]]];
       [cell.end_station setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"end_station"]]];
    [cell.buy setTag:indexPath.row];
    [cell.buy addTarget:self action:@selector(buyticker:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    //ceshi
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [stationArray objectAtIndex:indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@",[dic objectForKey:@"trainOpp"]];
    NSString *url = [NSString stringWithFormat:@"http://apis.juhe.cn/train/s?name=%@&key=%@",[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],APPKEY];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTag:1];
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
                NSDictionary *dicc = [dic objectForKey:@"result"];
                stationArray = [dicc objectForKey:@"data"];
                [self.table reloadData];
                [self.total setText:[NSString stringWithFormat:@"共%@条线路",[dicc objectForKey:@"totalcount"]]];

            }
            else
            {
                TrianTimeViewController *train = [[TrianTimeViewController alloc]initWithNibName:@"TrianTimeViewController" bundle:nil];
                train.dictonary = dic;
                [self.navigationController pushViewController:train animated:YES];
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
    [self.hud removeFromSuperview];
    [self.hud show:NO];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络错误，请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
  
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showInView:(UIView *) view
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self.chooseView setAlpha:1.0f];
    [self.chooseView.layer addAnimation:animation forKey:@"DDLocateView"];
 
//    [self.chooseView setFrame:CGRectMake(0, [[UIScreen mainScreen] applicationFrame].size.height-215, 320, 215)];
    self.chooseView.frame = CGRectMake(0, self.view.frame.size.height - self.chooseView.frame.size.height, self.chooseView.frame.size.width, self.chooseView.frame.size.height);
    [view addSubview:self.chooseView];
}

- (IBAction)chooseBtnFunction:(id)sender {

    [self showInView:self.view];
    
}

- (IBAction)changStartAndEnd:(id)sender {
    [self.chooseView removeFromSuperview];
    NSString *temp = nil;
    temp = self.start.text;
    [self.start setText:self.end.text];
    [self.end setText:temp];
    [self refrashData:sender];

    
}
//buyticker
-(void)buyticker:(UIButton *)sender
{
    
    
    
    
    NSDictionary *dic = [stationArray objectAtIndex:sender.tag];
    NSString *startPlace = [NSString stringWithFormat:@"%@",[dic objectForKey:@"start_staion"]];
    NSString *endPlace = [NSString stringWithFormat:@"%@",[dic objectForKey:@"end_station"]];
    NSString *checi =[NSString stringWithFormat:@"%@",[dic objectForKey:@"trainOpp"]];

    //获得系统时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *  morelocationString=[dateformatter stringFromDate:senddate];
    NSLog(@"%@",morelocationString);
    webviewViewController *webVC = [[webviewViewController alloc
                                     ]initWithNibName:@"webviewViewController" bundle:nil];
    webVC.urlString =[NSString stringWithFormat:@"http://m.tieyou.com/buy/home.html?from=%@&to=%@&ymd=%@&checi=%@&utm_source=techistoner",startPlace,endPlace,morelocationString,checi] ;
    webVC.flagVC = 2;//标识是否要左上角菜单按钮

    [self.navigationController pushViewController:webVC animated:YES];
    
    
}

//picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [typeArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",[typeArray objectAtIndex:row]];
}



-(void)selectTrainType:(UIBarButtonItem *)sender
{
    NSInteger row = [self.picker selectedRowInComponent:0];
    if (row==0) {
        self.typeString = nil;
    }
    else
    {
    self.typeString = [NSString stringWithFormat:@"%@",[typeArray objectAtIndex:row]];
    }
    [self refrashData:[NSString stringWithFormat:@"%@",[typeArray objectAtIndex:row]]];
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self.chooseView setAlpha:0.0f];
    [self.chooseView.layer addAnimation:animation forKey:@"TSLocateView"];
    [self.chooseView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
//    [self.chooseView removeFromSuperview];

}
-(void)cancelSelect:(UIBarButtonItem *)sender
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self.chooseView setAlpha:0.0f];
    [self.chooseView.layer addAnimation:animation forKey:@"TSLocateView"];
    [self.chooseView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
 

//    [self.chooseView removeFromSuperview];
}

@end
