//
//  AppDelegate.h
//  Train-special
//
//  Created by GST_MAC02 on 14-1-15.
//  Copyright (c) 2014年 GST_MAC02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *trainCollection;
@property (strong, nonatomic) NSMutableArray *stationCollection;
@property (strong, nonatomic) NSMutableArray *trainHistory;
@property (strong, nonatomic) NSMutableArray *stationHistory;
@end
