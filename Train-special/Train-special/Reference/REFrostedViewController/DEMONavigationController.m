//
//  DEMONavigationController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMONavigationController.h"
#import "DEMOMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface DEMONavigationController ()

@property (strong, readwrite, nonatomic) DEMOMenuViewController *menuViewController;

@end

@implementation DEMONavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
  //  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
 
//    [self.view addGestureRecognizer:pan];
    
}

- (void)showMenu
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"showmenu" object:self];
    
    [self.frostedViewController presentMenuViewController];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    
    [self.frostedViewController panGestureRecognized:sender];
}

@end
