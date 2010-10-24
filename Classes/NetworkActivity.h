//
//  NetworkActivity.h
//  WhiteLabel
//
//  Created by Barry Burton on 10/24/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkActivity : NSObject {
	int networkOperationCount;
}

+ (NetworkActivity *)sharedNetworkActivity;

- (void)operationStarted;
- (void)operationEnded;

@end
