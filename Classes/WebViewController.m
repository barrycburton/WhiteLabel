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

    NSString *htmlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL];
	
    if ( htmlString ) {
        self.webBody = [NSString stringWithFormat:htmlString, self.webTitle, self.webTitle, HTML];

        NSURL *baseURL = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] isDirectory:YES];
        if ( self.webView ) {
            [self.webView loadHTMLString:webBody baseURL:baseURL];
        }
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // TODO start with view covered and reveal it here
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
        NSURL *baseURL = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] isDirectory:YES];
		[self.webView loadHTMLString:webBody baseURL:baseURL];
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
	[self setURL:nil andTitle:nil andHTML:nil];
	[super viewDidDisappear: animated];
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
