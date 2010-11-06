//
//  Feed.h
//  WhiteLabel
//
//  Created by Barry Burton on 10/7/10.
//  Copyright 2010 Fonetik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RootViewController;

@interface Feed : NSObject <NSXMLParserDelegate> {
	NSArray *list;
	NSURL *feedURL;
	NSString *contentTitle;
	RootViewController *parent;
	
	NSMutableData *receivedData;
	NSMutableArray *newList;
	NSMutableDictionary *newEntry;
	NSMutableString *dataString;
	
	NSDate *lastUpdated;
	
	BOOL parsingEntry;
	BOOL probablyFeed;
	BOOL probablyPage;
	BOOL shouldFetchUpdate;
	BOOL isUpdating;
}

@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) NSURL *feedURL;
@property (nonatomic, retain) NSString *contentTitle;
@property (nonatomic, assign) RootViewController *parent;

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSMutableArray *newList;
@property (nonatomic, retain) NSMutableDictionary *newEntry;
@property (nonatomic, retain) NSMutableString *dataString;

@property (nonatomic, retain) NSDate *lastUpdated;

@property (nonatomic, assign) BOOL isUpdating;

- (id)initWithParent:(RootViewController *)theParent;
- (void)setAddress:(NSString*)theAddress;
- (NSString *)getAddress;
- (NSString *)getTitle;
- (void)fetchUpdatedData;
- (unsigned)countOfList;
- (id)objectInListAtIndex:(unsigned)theIndex;

@end
