//
//  SelectViewController.m
//  Train-special
//
//  Created by GST_MAC01 on 14-1-15.
//  Copyright (c) 2014年 GST_MAC02. All rights reserved.
//

#import "SelectViewController.h"

@interface SelectViewController ()

@end

@implementation SelectViewController
{
    NSArray *searchResults;
    NSMutableArray *dataSource;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *plistURL = [bundle URLForResource:@"cities" withExtension:@"plist"];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    dataSource = [self dictory2array:dictionary];

    self.cities = dictionary;
    NSArray *keys = [self.cities allKeys];

    
    self.alphabet = [keys sortedArrayUsingSelector:@selector(compare:)];
    
    NSLog(@"alphabet %@",self.alphabet);

  }

- (NSMutableArray *)dictory2array:(NSDictionary *)dic
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSArray *keys = [dic allKeys];
    
    for (int i = 0; i < [keys count]; ++i) {
        NSMutableArray *values = [dic objectForKey:[keys objectAtIndex:i]];
        for (int j = 0; j < [values count]; ++j) {
            [arr addObject:[values objectAtIndex:j]];
        }
    }
    return arr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return 1;
    }else{
        return [self.cities count];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSLog(@"searchResults count %d",[searchResults count]);
        return [searchResults count];
    }else{
    NSString *key = [self.alphabet objectAtIndex:section];
//    NSLog(@"key : %@",key);
//    NSArray *obj = [self.cities objectForKey:key];
//    NSLog(@"obj :%@",obj);
        return [[self.cities objectForKey:key] count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *GroupedTableViewIdentifier = @"GroupedTableViewIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableViewIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupedTableViewIdentifier];
    }

    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        cell.textLabel.text = [searchResults objectAtIndex:row];
    }else
    {
        NSString *key = [self.alphabet objectAtIndex:section];
        NSArray *citys = [self.cities objectForKey:key];
        
    cell.textLabel.text = [citys objectAtIndex:row];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    return [self.alphabet objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }

    return self.alphabet;
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
}
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
//    self.navigationController.navigationBarHidden = YES;
 
}
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
//    self.navigationController.navigationBarHidden = NO;

}
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
//    self.navigationController.navigationBarHidden = NO;

}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSLog(@"filterContentForSearchText ");
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
//    for (NSObject *temp in dataSource) {
//        NSLog(@"%@",temp);
//    }
    searchResults = [dataSource filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"searchDisplayController ");
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

@end
