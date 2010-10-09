//
//  WebViewController.h
//  WhiteLabel
//
//  Created by Barry Burton on 10/6/10.
//  Copyright 2010 Fonetik. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate> {
	NSURL *webURL;
	NSString *webTitle;
	NSString *webBody;
	UIWebView *webView;
}

@property (nonatomic, copy) NSString *webTitle;
@property (nonatomic, copy) NSString *webBody;
@property (nonatomic, copy) NSURL *webURL;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (void)setURL:(NSURL *)URL andTitle:(NSString *)title andHTML:(NSString *)HTML;

@end
