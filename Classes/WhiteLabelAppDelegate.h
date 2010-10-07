//
//  White_LabelAppDelegate.h
//  White Label
//
//  Created by Barry Burton on 9/19/10.
//  Copyright Gravity Mobile 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhiteLabelAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
	RootViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@end

