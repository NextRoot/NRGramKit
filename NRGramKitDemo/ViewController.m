//
//  ViewController.m
//  NRGramKitDemo
//
//  Created by Raul Andrisan on 5/22/12.
//  Copyright (c) 2012 NextRoot. All rights reserved.
//

#import "ViewController.h"
#import "NRGramKit.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize tableView;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self!=nil)
    {
        currentDataSource = [[NSArray alloc]init ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[NRGramKit getMediaPopularWithCallback:^(NSArray* popularMedia,IGPagination* pagination)
     {
         currentDataSource = popularMedia;
         [self.tableView reloadData];
         
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    IGMedia* media = [currentDataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = media.user.full_name;
    cell.detailTextLabel.text = media.user.username;
    
    return cell;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



@end
