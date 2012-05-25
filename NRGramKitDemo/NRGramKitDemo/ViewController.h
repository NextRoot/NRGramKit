//
//  ViewController.h
//  NRGramKitDemo
//
//  Created by Raul Andrisan on 5/22/12.
//  Copyright (c) 2012 NextRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray* currentDataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
