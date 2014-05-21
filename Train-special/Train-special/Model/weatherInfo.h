//
//  weatherInfo.h
//  Train-special
//
//  Created by Techistoner on 14-4-22.
//  Copyright (c) 2014年 GST_MAC02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
@protocol weatherDelegate <NSObject>

@optional
-(void)weatherinfo:(NSDictionary *)dic;

@end
@interface weatherInfo : NSObject<ASIHTTPRequestDelegate>
@property(assign,nonatomic)id<weatherDelegate> delegate;
-(void)QueryWeather:(NSString *)cityName;

@end
