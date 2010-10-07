//
//  RootViewController.h
//  White Label
//
//  Created by Barry Burton on 9/19/10.
//  Copyright Gravity Mobile 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
	UITableView *tableView;
	WebViewController	*webViewController;
	Feed *feed;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) WebViewController	*webViewController;
@property (nonatomic, retain) Feed *feed;

- (void)loadAddress:(NSString *) address;
- (void)target1;

@end
