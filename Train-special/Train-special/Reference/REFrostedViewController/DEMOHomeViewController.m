//
//  DEMOHomeViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOHomeViewController.h"
#import "DEMONavigationController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "TrianTimeViewController.h"
#import "StSViewController.h"
#import "TSLocateView.h"
#define kDuration 0.3


#import "AppDelegate.h"

@interface DEMOHomeViewController ()
{
    NSArray *typeArray;
    NSMutableArray *trainArray;
    int tag;
    bool isSelectVis;//标示选择试图是否显示
    UILabel *taplabel;//未设置天气时的提示
    UIAlertView *weatheralert;
    MBProgressHUD *waithud;
}

@end

@implementation DEMOHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //weather
    self.weather = [[weatherInfo alloc]init];
    [self.weather setDelegate:self];
    
	self.title = @"火车查询";
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:1.0];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"menu.png"]
                      forState:UIControlStateNormal];
    [button addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:button];

    self.navigationItem.leftBarButtonItem = left ;
    
    isSelectVis = NO;
    tag = 0;
    //车次查询界面
    [self.TrianName setHidden:NO];
    [self.TrainQueryBtn setHidden:NO];
    [self.TrainQueryBtn setTag:0];
    [self.chooseTrain setHidden:NO];
    [self.chooseTrain setTag:0];
    [self.chooseStart setTag:1];
    [self.chooseEnd setTag:2];
    [self.chooseTrain addTarget:self action:@selector(gotoSelecView:) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseStart addTarget:self action:@selector(gotoSelecView:) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseEnd addTarget:self action:@selector(gotoSelecView:) forControlEvents:UIControlEventTouchUpInside];
    //站站查询
    [self.chooseStart setHidden:YES];
    [self.chooseEnd setHidden:YES];
    [self.StationQueryBtn setHidden:YES];
    [self.StationQueryBtn setTag:1];
    [self.OriginPalce setHidden:YES];
    [self.Destination setHidden:YES];
    [self.ChangBtn setHidden:YES];
    [self.ChangBtn addTarget:self action:@selector(changOringlandDest:) forControlEvents:UIControlEventTouchUpInside];
    [self.TrainBtn setTag:0];
    [self.StationBtn setTag:1];
    [self.TrainBtn addTarget:self action:@selector(changView:) forControlEvents:UIControlEventTouchUpInside];
    [self.StationBtn addTarget:self action:@selector(changView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.TrainQueryBtn addTarget:self action:@selector(QueryFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.StationQueryBtn addTarget:self action:@selector(QueryFunction:) forControlEvents:UIControlEventTouchUpInside];
//    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//    self.hud.labelText = @"正在查询";
//    self.hud.dimBackground = NO;
    [self setProcess:YES];
    
    
    //
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKB:) name:@"showmenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    // 创建DB的路径
    databasePath = [[NSBundle mainBundle] pathForResource:@"train" ofType:@"db"];
    //NSLog(@"databasePath == %@",databasePath);
    dbPath=[databasePath UTF8String];
    if (sqlite3_open(dbPath, &cityDB)==SQLITE_OK) {
        NSLog(@"打开数据库成功");
    }
    else
    {
        NSLog(@"打开数据库失败");
    }
    
//设置天气的label
    taplabel = [[UILabel alloc]initWithFrame:CGRectMake(89, 362, 130, 19)];
    [taplabel setText:@"双击来获取天气"];
    [taplabel setTextColor:[UIColor lightTextColor]];
    [taplabel setUserInteractionEnabled:YES];
    [self.view addSubview:taplabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeweather)];
    tap.numberOfTapsRequired = 2;
    [taplabel addGestureRecognizer:tap];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    sqlite3_close(cityDB);

}

-(void)keyboardWillShow:(id)sender
{
    [self.selectView removeFromSuperview];
    
    
    
}

-(IBAction)hideKB:(id)sender
{
    [self.TrianName resignFirstResponder];
    [self.OriginPalce resignFirstResponder];
    [self.Destination resignFirstResponder];
}

-(void)changOringlandDest:(id)sender//切换目的地和到达地
{
    NSString *temp = nil;
    temp = self.OriginPalce.text;
    [self.OriginPalce setText:self.Destination.text];
    [self.Destination setText:temp];
    
}

-(void)changView :(UIButton *)sender
{
//    [self.selectView removeFromSuperview];
    [self cancelSelect:nil];
    [self hideKB:nil];
    if (sender.tag==0) {
        tag = 0;
        [self.StationQueryBtn setHidden:YES];
        [self.OriginPalce setHidden:YES];
        [self.Destination setHidden:YES];
        [self.ChangBtn setHidden:YES];
        [self.chooseStart setHidden:YES];
        [self.chooseEnd setHidden:YES];
        [self.chooseTrain setHidden:NO];
        [self.TrianName setHidden:NO];
        [self.TrainQueryBtn setHidden:NO];
    }
    else
    {
        tag = 1;
        [self.StationQueryBtn setHidden:NO];
        [self.OriginPalce setHidden:NO];
        [self.Destination setHidden:NO];
        [self.ChangBtn setHidden:NO];
        [self.chooseStart setHidden:NO];
        [self.chooseEnd setHidden:NO];
        [self.chooseTrain setHidden:YES];
        [self.TrianName setHidden:YES];
        [self.TrainQueryBtn setHidden:YES];
    }
}

-(NSMutableArray *)setTrainList:(NSString *)kind
{
    NSMutableArray *secondaryList = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbPath, &cityDB)==SQLITE_OK) {
//        NSLog(@"%@");
        NSString *insertSQL = [[NSString alloc] initWithFormat:@"select name from t_che where name like '%%%@%%'",[kind substringWithRange:NSMakeRange(0, 1)]];//
        //NSLog(@"insertSQL = %@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare(cityDB, insert_stmt, -1, &statement, NULL);
        //NSLog(@"sqlite3_step(statement) == %d",sqlite3_step(statement));
        while (sqlite3_step(statement)==SQLITE_ROW) {
            NSString *nameFromSql = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
           // NSLog(@"nameFromSql == %@",nameFromSql);
            [secondaryList addObject:nameFromSql];
        }
        sqlite3_finalize(statement);
//        sqlite3_close(cityDB);
        
    }
    return secondaryList;
}


- (void)showInView:(UIView *) view
{
    if (!isSelectVis) {
    isSelectVis = YES;
    [self.toolright setTarget:self];
    [self.toolleft setTarget:self];
    [self.toolleft setAction:@selector(cancelSelect:)];
    [self.toolright setAction:@selector(selectTrainType:)];
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    [self.selectView setAlpha:1.0f];
    [self.selectView.layer addAnimation:animation forKey:@"DDLocateView"];
    self.selectView.frame = CGRectMake(0, self.view.frame.size.height - self.selectView.frame.size.height, self.selectView.frame.size.width, self.selectView.frame.size.height);
    [view addSubview:self.selectView];
    }
    else{
        [self cancelSelect:nil];
        isSelectVis = NO;
    }
}


-(void)gotoSelecView :(UIButton *)sender
{
//    [self.selectView removeFromSuperview];
    [self hideKB:nil];
    
    tag = sender.tag;
    if (tag == 0) {
                NSArray *trainKind = [NSArray arrayWithObjects:@"C-城际高速",@"D-动车组",@"G-高速动车",@"K-快速",@"L-临客",@"T-空调特快",@"Y-旅游列车",@"Z-直达特快",@"Q-其他",nil];
        typeArray = trainKind;
        trainArray = [self setTrainList: [trainKind objectAtIndex:self.secondRow]];//查数据库
        
    }else{
        //加载数据
        typeArray = nil;
        NSArray *province = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvincesAndCities.plist" ofType:nil]];
        typeArray = province;//读plist
        NSMutableArray *secondaryList = [[NSMutableArray alloc] init];
        secondaryList = [[typeArray objectAtIndex:self.secondRow]objectForKey:@"Cities"];
        trainArray = secondaryList;
    }
    
    NSLog(@"trainArray = %@",trainArray);
    [self.pickView reloadComponent:0];
    [self.pickView reloadComponent:1];
     [self showInView:self.view];
    
    
}

-(void)selectTrainType:(UIBarButtonItem *)sender
{
    NSInteger row = [self.pickView selectedRowInComponent:1];

    if (tag == 0) {
    
        [self.TrianName setText:[NSString stringWithFormat:@"%@",[trainArray objectAtIndex:row]]];
    
    }else if(tag == 1){
        [self.OriginPalce setText:[NSString stringWithFormat:@"%@",[[trainArray objectAtIndex:row]objectForKey:@"city" ]]];
    }else{
         [self.Destination setText:[NSString stringWithFormat:@"%@",[[trainArray objectAtIndex:row]objectForKey:@"city"]]];
    }

    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self.selectView setAlpha:0.0f];
    [self.selectView.layer addAnimation:animation forKey:@"TSLocateView"];
    [self.selectView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
 
    
}
-(void)cancelSelect:(UIBarButtonItem *)sender
{
    isSelectVis = NO;
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self.selectView setAlpha:0.0f];
    [self.selectView.layer addAnimation:animation forKey:@"TSLocateView"];
    [self.selectView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    
}

-(void)QueryFunction:(UIButton *)sender//查询数据
{
    
    [self hideKB:nil];
    
    if (sender.tag==0) {
        
        if (self.TrianName.text.length==0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"输入不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSString *url = [NSString stringWithFormat:@"http://apis.juhe.cn/train/s?name=%@&key=%@",[self.TrianName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],APPKEY];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
            [request setRequestMethod:@"GET"];
            [request setDelegate:self];
            [request setTag:0];
            [request startAsynchronous];
        }
    }
    else
    {
        if (self.OriginPalce.text.length==0||self.Destination.text.length==0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"输入不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSString *url = [NSString stringWithFormat:@"http://apis.juhe.cn/train/s2s?start=%@&end=%@&key=%@",[self.OriginPalce.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.Destination.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],APPKEY];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
            [request setRequestMethod:@"GET"];
            [request setDelegate:self];
            [request setTag:1];
            [request startAsynchronous];
        }
    }
    
    
}
#pragma mark alert


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *field = [alertView textFieldAtIndex:0];
    if (buttonIndex==1) {
        
        [self.weather QueryWeather:field.text];
    }
    
}

#pragma mark weatheinfo
-(void)changeweather{
    NSLog(@"tap");
    weatheralert = [[UIAlertView alloc]initWithTitle:@"请输入需要获取天气的城市" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [weatheralert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [weatheralert show];
}
-(void)weatherinfo:(NSDictionary *)dic
{
    NSString *error_code =[NSString stringWithFormat:@"%@", [dic valueForKey:@"error_code"]];
    if (![error_code isEqualToString:@"0"]) {
        [self handeError:error_code];
    }
    else{
    
    }
    
    

}
-(void)handeError:(NSString *)errorcode
{
//    错误码	说明
// 	203901	查询城市不能为空
// 	203903	查询出错，请重试
// 	203902	查询不到该城市的天气
    
    if ([errorcode isEqualToString:@"203901"]) {
        [MBProgressHUD showMessag:@"查询城市不能为空" toView:nil];
    }
    else if ([errorcode isEqualToString:@"203902"]){
        [MBProgressHUD showMessag:@"查询不到该城市的天气" toView:nil];
    }
    else if ([errorcode isEqualToString:@"203903"]){
        [MBProgressHUD showMessag:@"查询出错，请重试" toView:nil];
   
    }
    
}

#pragma mark picker
//picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"didSelectRow");
    if(tag == 0){
        switch (component) {//车次
            case 0:
                NSLog(@"component == 0");
                trainArray = [self setTrainList: [typeArray objectAtIndex:row]];
                [pickerView selectRow:0 inComponent:1 animated:NO];
                [pickerView reloadComponent:1];
                self.secondRow = row;
                break;
            case 1:
                
                break;
            default:
                break;
        }

    }else{
        switch (component) {//城市
            case 0:
                NSLog(@"component == 0");
                trainArray = [[typeArray objectAtIndex:row] objectForKey:@"Cities"];
                [pickerView selectRow:0 inComponent:1 animated:NO];
                [pickerView reloadComponent:1];
                self.secondRow = row;
                break;
            case 1:
                
                break;
            default:
                break;
        }
//        [pickerView selectRow:0 inComponent:1 animated:NO];
//        [pickerView reloadComponent:1];

    }
        
    
   }


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            
            return [typeArray count];
            break;
        case 1:
            
            return [trainArray count];
            break;
        default:
            return 0;
            break;
    }

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (tag == 0) {
        switch (component) {
            case 0:
                return [NSString stringWithFormat:@"%@",[typeArray objectAtIndex:row]];
                break;
            case 1:
                return [NSString stringWithFormat:@"%@",[trainArray objectAtIndex:row]];
                break;
            default:
                return 0;
                break;
        }

    }else{
        switch (component) {
            case 0:
                return [[typeArray objectAtIndex:row] objectForKey:@"State"];
                break;
            case 1:
                return [[trainArray objectAtIndex:row] objectForKey:@"city"];
                break;
            default:
                return nil;
                break;
        }
    }
   }


- (void)requestStarted:(ASIHTTPRequest *)request
{
//    [self.view addSubview:self.hud];
//    [self.hud show:YES];
    [self setProcess:YES];
    NSLog(@"******");
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    appdelegate;
//    [self.hud removeFromSuperview];
//    [self.hud show:NO];
    [self setProcess:NO];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];
    NSString *stataCode = [dic objectForKey:@"resultcode"];
    switch ([stataCode intValue]) {
        case 200:
        {
            if (request.tag==0) {//车次查询
                //写历史记录
                if ([del.trainHistory count]==0) {
  
                    [del.trainHistory addObject:self.TrianName.text];
                    [[NSUserDefaults standardUserDefaults]setObject:del.stationCollection forKey:@"tHistory"];
                }
                else
                {
                BOOL is_Exist= NO;
                for (int i =0 ; i<[del.trainHistory count]; i++) {
                    NSString *juge = [NSString stringWithFormat:@"%@",[del.trainHistory objectAtIndex:i]];
                    if ([self.TrianName.text isEqualToString:juge]) {
                        is_Exist = YES;
                        break;
                    }
                    else
                    {
                        is_Exist= NO;
                    }
                }
                if (is_Exist == NO) {
                    
                    [del.trainHistory addObject:self.TrianName.text];
                    [[NSUserDefaults standardUserDefaults]setObject:del.trainHistory forKey:@"tHistory"];
                }
          
                }
                TrianTimeViewController *train = [[TrianTimeViewController alloc]initWithNibName:@"TrianTimeViewController" bundle:nil];
                train.dictonary = dic;
                [self.navigationController pushViewController:train animated:YES];

            }
            else if (request.tag==1)//
            {
                //写历史记录
            NSString *string = [NSString stringWithFormat:@"%@-%@",self.OriginPalce.text,self.Destination.text];
                if ([del.stationHistory count]==0) {
                    [del.stationHistory addObject:string];
                 [[NSUserDefaults standardUserDefaults]setObject:del.stationHistory forKey:@"sHistory"];
                }
                else
                {
                    BOOL is_Exist= NO;
                    for (int i =0 ; i<[del.stationHistory count]; i++) {
                        NSString *juge = [NSString stringWithFormat:@"%@",[del.stationHistory objectAtIndex:i]];
                        if ([string isEqualToString:juge]) {
                            is_Exist = YES;
                            break;
                        }
                        else
                        {
                            is_Exist= NO;
                        }
                    }
                    if (is_Exist == NO) {
                        [del.stationHistory addObject:string];
                        [[NSUserDefaults standardUserDefaults]setObject:del.stationHistory forKey:@"sHistory"];
                    }
               
                }
                StSViewController *stsVC = [[StSViewController alloc]initWithNibName:@"StSViewController" bundle:nil];
                stsVC.stsDic = dic;
                stsVC.startString = self.OriginPalce.text;
                stsVC.endString = self.Destination.text;
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
//    [self.hud removeFromSuperview];
//    [self.hud show:NO];
    [self setProcess:NO];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络错误，请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)setProcess:(BOOL)status{
    if(status){
        if(waithud == nil){
            waithud  = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:waithud];
        }
        if (waithud.isHidden) {
            [waithud show:YES];
            [waithud setHidden:NO];
        }
    }
    else {
        if (waithud != nil&&!waithud.isHidden) {
            [waithud show:NO];
            [waithud setHidden:YES];
        }
    }
}
@end
