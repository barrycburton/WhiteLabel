//
//  ChangeSiteViewController.h
//  WhiteLabel
//
//  Created by Barry Burton on 10/8/10.
//  Copyright 2010 Fonetik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface ChangeSiteViewController : UIViewController <UITextFieldDelegate> {
	UITextField *textField;
	RootViewController *parent;
	NSString *initialText;
}

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, assign) IBOutlet RootViewController *parent;
@property (nonatomic, retain) NSString *initialText;

- (void)setText:(NSString *)newText;

- (IBAction)acceptAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end
