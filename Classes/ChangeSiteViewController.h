//
//  ChangeSiteViewController.h
//  WhiteLabel
//
//  Created by Barry Burton on 10/8/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface ChangeSiteViewController : UIViewController <UITextFieldDelegate> {
	UITextField *textField;
	RootViewController *parent;
}

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, assign) IBOutlet RootViewController *parent;

- (IBAction)acceptAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end
