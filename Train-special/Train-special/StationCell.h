//
//  StationCell.h
//  Train-special
//
//  Created by GST_MAC02 on 14-1-16.
//  Copyright (c) 2014年 GST_MAC02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *trainOpp;
@property (weak, nonatomic) IBOutlet UILabel *start_staion;
@property (weak, nonatomic) IBOutlet UILabel *end_station;
@property (weak, nonatomic) IBOutlet UILabel *leave_time;
@property (weak, nonatomic) IBOutlet UILabel *arrived_time;
@property (weak, nonatomic) IBOutlet UILabel *mileage;
@property (weak, nonatomic) IBOutlet UIButton *buy;

@end
