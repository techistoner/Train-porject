//
//  SelectViewController.h
//  Train-special
//
//  Created by GST_MAC01 on 14-1-15.
//  Copyright (c) 2014年 GST_MAC02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>
@property (nonatomic,retain)NSDictionary *cities;
@property (nonatomic,retain)NSArray *alphabet;
//@property (nonatomic,retain)NSArray *searchResults;
//@property (nonatomic,retain)NSArray *dataSource;
- (NSMutableArray *)dictory2array:(NSDictionary *)dic;
@end
