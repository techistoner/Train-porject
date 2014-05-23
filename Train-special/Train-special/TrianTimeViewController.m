//
//  TrianTimeViewController.m
//  Train-special
//
//  Created by GST_MAC02 on 14-1-15.
//  Copyright (c) 2014年 GST_MAC02. All rights reserved.
//

#import "TrianTimeViewController.h"
#import "Cell.h"
#import "AppDelegate.h"
@interface TrianTimeViewController ()
{
    NSArray *stationArray;
    UIButton *rightbutton ;
}

@end

@implementation TrianTimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"车次查询";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDictionary *result = [self.dictonary objectForKey:@"result"];
    NSDictionary *train_info = [result objectForKey:@"train_info"];
    
    NSLog(@"test=%@",result);
    
    stationArray = [result objectForKey:@"station_list"];
    
    [self.TrainName  setText:[NSString stringWithFormat:@"%@",[train_info objectForKey:@"name"]]];
     [self.StartStation  setText:[NSString stringWithFormat:@"%@",[train_info objectForKey:@"start"]]];
     [self.EndStation  setText:[NSString stringWithFormat:@"%@",[train_info objectForKey:@"end"]]];
     [self.Mileage  setText:[NSString stringWithFormat:@"%@",[train_info objectForKey:@"mileage"]]];
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 172, 320, [[UIScreen mainScreen] applicationFrame].size.height-172) style:UITableViewStylePlain];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    [self.view addSubview:self.table];
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

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)isCollected{//判断是否收藏过
    appdelegate;
    NSString *string = [NSString stringWithFormat:@"%@",self.TrainName.text];
    NSLog(@"trainCollection%@",del.trainCollection);
    if (![del.trainCollection count]==0) {
        BOOL is_Exist= NO;
        for (int i =0 ; i<[del.trainCollection count]; i++) {
            NSString *juge = [NSString stringWithFormat:@"%@",[del.trainCollection objectAtIndex:i]];
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
    
    appdelegate;
    NSString *string = [NSString stringWithFormat:@"%@",self.TrainName.text];
    NSLog(@"%@",string);
        NSLog(@"%d",[del.trainCollection count]);
        if ([del.trainCollection count]==0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"收藏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [del.trainCollection addObject:string];
            [[NSUserDefaults standardUserDefaults]setObject:del.trainCollection forKey:@"t"];
            [rightbutton setBackgroundImage:[UIImage imageNamed:@"collected.png"]forState:UIControlStateNormal];
        }
        else
        {
            BOOL is_Exist= NO;
            for (int i =0 ; i<[del.trainCollection count]; i++) {
                NSString *juge = [NSString stringWithFormat:@"%@",[del.trainCollection objectAtIndex:i]];
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
                [del.trainCollection addObject:string];
                [[NSUserDefaults standardUserDefaults]setObject:del.trainCollection forKey:@"t"];
                [rightbutton setBackgroundImage:[UIImage imageNamed:@"collected.png"]forState:UIControlStateNormal];

            }
        }
    
}

#pragma mark tableview
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [stationArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"Cell";
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:
                               SimpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"Cell" owner:self options:nil];
        cell = nib[0];
    }
    NSDictionary *dic = [stationArray objectAtIndex:indexPath.row];
    NSLog(@"%@",[dic objectForKey:@"train_id"]);
    [cell.train_id setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"train_id"]]];
    [cell.station_name setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"station_name"]]];
    [cell.arrived_time setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"arrived_time"]]];
    [cell.leave_time setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"leave_time"]]];
    [cell.mileage setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"mileage"]]];

    return cell;
}

@end
