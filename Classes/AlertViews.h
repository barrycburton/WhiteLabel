//
//  AlertViews.h
//  White Label
//
//  Created by Barry C Burton on 5/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


void AlertWithError(NSError *error);
void AlertWithMessage(NSString *message);
void AlertWithMessageAndDelegate(NSString *message, id delegate);
