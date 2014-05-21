//
//  TrianTimeViewController.h
//  Train-special
//
//  Created by GST_MAC02 on 14-1-15.
//  Copyright (c) 2014年 GST_MAC02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrianTimeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *TrainName;
@property (weak, nonatomic) IBOutlet UILabel *StartStation;
@property (weak, nonatomic) IBOutlet UILabel *EndStation;
@property (weak, nonatomic) IBOutlet UILabel *Mileage;
@property (strong, nonatomic) NSDictionary *dictonary;

@property (strong, nonatomic) UITableView *table;
//@property (nonatomic) int collectFlag;//用来判断是哪个收藏类型

@end
