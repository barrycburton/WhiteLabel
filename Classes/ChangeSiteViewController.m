//
//  ChangeSiteViewController.m
//  WhiteLabel
//
//  Created by Barry Burton on 10/8/10.
//  Copyright 2010 Fonetik. All rights reserved.
//

#import "ChangeSiteViewController.h"
#import "RootViewController.h"

@implementation ChangeSiteViewController

@synthesize parent, textField, initialText;


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

	self.title = NSLocalizedString(@"Change Site", @"ChangeSiteKey");
	
	if ( self.initialText ) {
		self.textField.text = self.initialText;
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.textField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear: animated];
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

- (void)setText:(NSString *)newText {
	if ( self.textField ) {
		self.textField.text = newText;
	} else {
		self.initialText = newText;
	}
}

- (IBAction)acceptAction:(id)sender {
	self.initialText = textField.text;
	[self.parent loadAddress:textField.text];
	[self.textField resignFirstResponder];
	[self.parent dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelAction:(id)sender {
	[self.textField resignFirstResponder];
	[self.parent dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textField) {
		[self acceptAction:self.textField];
    }
    return YES;
}

- (void)dealloc {
	self.textField = nil;
	self.parent = nil;
	self.initialText = nil;
    [super dealloc];
}


@end
