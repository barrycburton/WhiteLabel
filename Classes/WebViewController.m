//
//  WebViewController.m
//  WhiteLabel
//
//  Created by Barry Burton on 10/6/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

@synthesize webURL, webTitle, webBody, webView;


- (void)setURL:(NSURL *)URL andTitle:(NSString *)title andHTML:(NSString *)HTML {
	self.webURL = URL;
	self.webTitle = title;
	self.webBody = HTML;
	self.title = title;
	[webView loadHTMLString:webBody baseURL:webURL];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations // anything except upside down
    return ((interfaceOrientation == UIInterfaceOrientationPortrait 
			 || interfaceOrientation == UIInterfaceOrientationLandscapeLeft 
			 || interfaceOrientation == UIInterfaceOrientationLandscapeRight );
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	if ( UIWebViewNavigationTypeOther == navigationType ) {
		return YES;
	} else {
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.webView = nil;
	self.webTitle = nil;
	self.webBody = nil;
	self.webURL = nil;
    [super dealloc];
}


@end
