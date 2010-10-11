//
//  RootViewController.h
//  White Label
//
//  Created by Barry Burton on 9/19/10.
//  Copyright Fonetik 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "Feed.h"

@interface RootViewController : UITableViewController {
	UITableView *tableView;
	WebViewController *webViewController;
	Feed *feed;
	
	UIBarButtonItem *refreshButton;
}

@property (nonatomic, retain) UITableView *rootTableView;
@property (nonatomic, retain) WebViewController	*webViewController;
@property (nonatomic, retain) Feed *feed;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, retain) UIView *oldView;


- (void)loadAddress:(NSString *) address;
- (NSString *)getAddress;
- (void)dataWasRefreshed;
- (IBAction)changeSite;
- (IBAction)refreshData;

@end
