//
//  SettingsViewController.h
//  WhiteLabel
//
//  Created by Barry Burton on 10/8/10.
//  Copyright 2010 Fonetik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
	RootViewController *parent;
	NSString *initialText;
	
	UITableView *tableView;
	UITextField *textField;
	
	UILabel *detailTextLabel;
}

@property (nonatomic, assign) RootViewController *parent;
@property (nonatomic, retain) NSString *initialText;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UITextField *textField;

- (IBAction)acceptAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end
