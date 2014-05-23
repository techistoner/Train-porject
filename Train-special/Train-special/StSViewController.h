//
//  StSViewController.h
//  Train-special
//
//  Created by GST_MAC02 on 14-1-16.
//  Copyright (c) 2014年 GST_MAC02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"

@interface StSViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *start;
@property (weak, nonatomic) IBOutlet UILabel *end;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (strong , nonatomic) NSDictionary *stsDic;
@property (strong , nonatomic) NSString *startString;
@property (strong , nonatomic) NSString *endString;
@property (strong , nonatomic) NSString *typeString;


@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UIToolbar *tool;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tooleft;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolright;
//@property (nonatomic) int collectFlag;



- (IBAction)chooseBtnFunction:(id)sender;
- (IBAction)changStartAndEnd:(id)sender;
- (void)showInView:(UIView *)view;

@end
