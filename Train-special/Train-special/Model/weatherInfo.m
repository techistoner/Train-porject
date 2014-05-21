//
//  weatherInfo.m
//  Train-special
//
//  Created by Techistoner on 14-4-22.
//  Copyright (c) 2014年 GST_MAC02. All rights reserved.
//

#import "weatherInfo.h"

@implementation weatherInfo

-(void)QueryWeather:(NSString *)cityName{
    NSString *url = [NSString stringWithFormat:@"http://v.juhe.cn/weather/index?cityname=%@&key=1e833a17492661e98f5c83909c4bbbf8",[cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"start");

}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];
    [self.delegate weatherinfo:dic];
    //NSLog(@"%@",dic);
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
}
@end
