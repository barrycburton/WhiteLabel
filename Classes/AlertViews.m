//
//  AlertViews.m
//  White Label
//
//  Created by Barry C Burton on 5/6/09.
//  Copyright 2009 Fonetik. All rights reserved.
//

#import "AlertViews.h"


void AlertWithError(NSError *error) {
    NSString *message = [NSString stringWithFormat:@"Error! %@", [error localizedDescription]];
	AlertWithMessage(message);
}


void AlertWithMessage(NSString *message) {
	/* open an alert with an OK button */
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
	[alert show];
}


void AlertWithMessageAndDelegate(NSString *message, id delegate) {
	/* open an alert with OK and Cancel buttons */
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"] message:message delegate:delegate cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK", nil] autorelease];
	[alert show];
}
