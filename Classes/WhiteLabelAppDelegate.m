//
//  White_LabelAppDelegate.m
//  White Label
//
//  Created by Barry Burton on 9/19/10.
//  Copyright Fonetik 2010. All rights reserved.
//

#import "WhiteLabelAppDelegate.h"
#import "RootViewController.h"


@implementation WhiteLabelAppDelegate

@synthesize window, navigationController, rootViewController;



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    // TODO copy assets to documents directory
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    [[NSFileManager defaultManager] copyItemAtPath:[bundlePath stringByAppendingPathComponent:@"template.html"] 
                                    toPath:[documentsPath stringByAppendingPathComponent:@"template.html"]
                                    error:NULL];
    [[NSFileManager defaultManager] copyItemAtPath:[bundlePath stringByAppendingPathComponent:@"style.css"] 
                                    toPath:[documentsPath stringByAppendingPathComponent:@"style.css"]
                                    error:NULL];
    [[NSFileManager defaultManager] createDirectoryAtPath:[documentsPath stringByAppendingPathComponent:@"images"] withIntermediateDirectories:NO attributes:nil error:NULL];
    
    // Add the navigation controller's view to the window and display.
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	self.rootViewController = nil;
	self.navigationController = nil;
	self.window = nil;
	[super dealloc];
}


@end

