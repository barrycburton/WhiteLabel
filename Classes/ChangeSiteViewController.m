//
//  ChangeSiteViewController.m
//  WhiteLabel
//
//  Created by Barry Burton on 10/8/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import "ChangeSiteViewController.h"
#import "RootViewController.h"

@implementation ChangeSiteViewController

@synthesize parent, textField;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.title = NSLocalizedString(@"Change Site", @"ChangeSiteKey");
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear: animated];
	
	[textField becomeFirstResponder];
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.textField = nil;
}

- (IBAction)acceptAction:(id)sender {	
	[parent loadAddress: textField.text];
	[textField resignFirstResponder];
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelAction:(id)sender {
	[textField resignFirstResponder];
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textField) {
		[self dismissAction:self.textField];
    }
    return YES;
}

- (void)dealloc {
	self.textField = nil;
    [super dealloc];
}


@end
