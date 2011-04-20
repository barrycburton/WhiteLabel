//
//  NetworkActivity.m
//  WhiteLabel
//
//  Created by Barry Burton on 10/24/10.
//  Copyright 2010 Fonetik. All rights reserved.
//

#import "NetworkActivity.h"
#import <UIKit/UIKit.h>

static NetworkActivity *sharedInstance = nil;

@implementation NetworkActivity

+ (NetworkActivity *)sharedNetworkActivity {
	if ( sharedInstance == nil ) {
		sharedInstance = [[NetworkActivity alloc] init];
	}
	return sharedInstance;
}

- (void)updateIndicator {
	BOOL visibility = NO;
	if ( networkOperationCount > 0 ) {
		visibility = YES;
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible = visibility;
}

- (void)operationStarted {
	networkOperationCount++;
	[self updateIndicator];
}

- (void)operationEnded {
	if ( networkOperationCount > 0 ) {
		networkOperationCount--;
	}
	[self updateIndicator];
}

@end
