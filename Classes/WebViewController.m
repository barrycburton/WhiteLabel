//
//  WebViewController.m
//  WhiteLabel
//
//  Created by Barry Burton on 10/6/10.
//  Copyright 2010 Fonetik. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

@synthesize webURL, webTitle, webBody, webView;


- (void)setURL:(NSURL *)URL andTitle:(NSString *)title andHTML:(NSString *)HTML {
	self.webURL = URL;
	self.webTitle = title;
	self.webBody = [NSString stringWithFormat:@"<html><head><title>%@</title></head>\n<body style=\"width: 300px;\">\n<h1>%@</h1>\n%@</body></html>", self.webTitle, self.webTitle, HTML];
	if ( self.webView ) {
		[self.webView loadHTMLString:webBody baseURL:webURL];
	}
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ( self.webBody ) {
		[self.webView loadHTMLString:webBody baseURL:webURL];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:YES animated:animated]; 
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setToolbarHidden:NO animated:animated]; 
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear: animated];
	[self.webView loadHTMLString:nil baseURL:nil];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations // anything except upside down
    return ( (interfaceOrientation == UIInterfaceOrientationPortrait) 
			 || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) 
			 || (interfaceOrientation == UIInterfaceOrientationLandscapeRight) );
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
	self.webView = nil;
}


- (void)dealloc {
	self.webView = nil;
	self.webTitle = nil;
	self.webBody = nil;
	self.webURL = nil;
    [super dealloc];
}


@end
