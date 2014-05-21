//
//  DEMOHomeViewController.h
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "weatherInfo.h"

@interface DEMOHomeViewController : UIViewController<ASIHTTPRequestDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,weatherDelegate,UIAlertViewDelegate>
{
    sqlite3 *cityDB;
    const char *dbPath;
    NSString *databasePath;

}
@property (weak, nonatomic) IBOutlet UIButton *TrainBtn;
@property (weak, nonatomic) IBOutlet UIButton *StationBtn;
@property (weak, nonatomic) IBOutlet UITextField *TrianName;
@property (weak, nonatomic) IBOutlet UITextField *OriginPalce;
@property (weak, nonatomic) IBOutlet UITextField *Destination;
@property (weak, nonatomic) IBOutlet UIButton *TrainQueryBtn;
@property (weak, nonatomic) IBOutlet UIButton *StationQueryBtn;
@property (weak, nonatomic) IBOutlet UIButton *ChangBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseTrain;
@property (weak, nonatomic) IBOutlet UIButton *chooseStart;
@property (weak, nonatomic) IBOutlet UIButton *chooseEnd;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) weatherInfo *weather;

-(IBAction)hideKB:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolright;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolleft;
@property ( nonatomic) int secondRow;

@end
