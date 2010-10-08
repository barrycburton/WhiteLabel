//
//  Feed.m
//  WhiteLabel
//
//  Created by Barry Burton on 10/7/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import "Feed.h"
#import "AlertViews.h"
#import "RootViewController.h"

@implementation Feed

@synthesize list, feedURL, contentTitle, parent;
@synthesize receivedData, newList, newEntry, dataString;


- (id)initWithParent:(RootViewController *)theParent {
    if (self = [super init]) {
		self.list = [[[NSArray alloc] init] autorelease];
		parsingEntry = NO;
		feedURL = nil;
		self.parent = theParent;
    }
    return self;
}

- (void)setAddress:(NSString*)theAddress {
	if ( ![theAddress hasPrefix: @"http://" ] && ![theAddress hasPrefix: @"https://" ] ) {
		theAddress = [@"http://" stringByAppendingString:theAddress];
	}
	self.feedURL = [NSURL URLWithString:theAddress];
}

- (NSString *)getAddress {
	return [self.feedURL absoluteString];
}

- (unsigned)countOfList {
	return [self.list count];
}

- (id)objectInListAtIndex:(unsigned)theIndex {
    return [self.list objectAtIndex:theIndex];
}


- (void)fetchUpdatedData {
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:self.feedURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	
	/* create the NSMutableData instance that will hold the received data */
	if ( !self.receivedData ) {
		self.receivedData = [[[NSMutableData alloc] initWithLength:0] autorelease];
	}
	
	/* Create the connection with the request and start loading the
	 data. The connection object is owned both by the creator and the
	 loading system. */
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest 
																  delegate:self 
														  startImmediately:YES];
	
	if (connection == nil) {
		/* inform the user that the connection failed */
		NSLog(@"Connection is broken.");
		AlertWithMessage(@"Connection is broken.");
	} else {
		NSLog(@"Starting connection to %@", feedURL);
	}
}


#pragma mark NSURLConnection delegate methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    /* This method is called when the server has determined that it has
	 enough information to create the NSURLResponse. It can be called
	 multiple times, for example in the case of a redirect, so each time
	 we reset the data. */
	
    [self.receivedData setLength:0];
	
	// save the actual URL that was finally loaded (redirect handling)
	self.feedURL = [response URL];

	if ([response isKindOfClass:[NSHTTPURLResponse self]]) {
		// log the http headers
		NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
		NSLog(@"%@", [headers description]);
	}
	
	// decide what kind of document this is
	probablyPage = NO;
	probablyFeed = NO;
	if ( [[response MIMEType] rangeOfString: @"html" options: NSCaseInsensitiveSearch].location != NSNotFound ) {
		// probably html
		probablyPage = YES;
	} else if ( [[response MIMEType] rangeOfString: @"xhtml" options: NSCaseInsensitiveSearch].location != NSNotFound ) {
		// probably html
		probablyPage = YES;
	} else if ( [[response MIMEType] rangeOfString: @"xml" options: NSCaseInsensitiveSearch].location != NSNotFound ) {
		// probably atom
		probablyFeed = YES;
	} else if ( [[response MIMEType] rangeOfString: @"atom" options: NSCaseInsensitiveSearch].location != NSNotFound ) {
		// probably atom
		probablyFeed = YES;
	} else if ( [[response MIMEType] rangeOfString: @"rss" options: NSCaseInsensitiveSearch].location != NSNotFound ) {
		// probably rss
		probablyFeed = YES;
	}
	
	NSLog(@"MIME Type indicates:");
	if ( probablyFeed ) {
		NSLog(@"Probably a Feed (RSS/Atom)");
	} else if ( probablyPage ) {
		NSLog(@"Probably a Web Page (HTML)");
	} else {
		NSLog(@"Nothing yet.");
	}
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    /* Append the new data to the received data. */
    [self.receivedData appendData:data];
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Connection started but failed later.");
	AlertWithError(error);
	[connection release];
}



- (void) connectionDidFinishLoading:(NSURLConnection *)connection {	
	[connection release];
	
	self.newList = [[NSMutableArray alloc] init];
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.receivedData];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	
	[parser parse];
	
	NSError *parseError = [parser parserError];
	
	NSLog(@"%@", [parseError description]);
	
	[parser release];
	
	self.receivedData = nil;
	self.newList = nil;
	self.newEntry = nil;
	self.dataString = nil;
	
	if ( shouldFetchUpdate ) {
		shouldFetchUpdate = NO;
		[self fetchUpdatedData];
	}
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (qName) {
        elementName = qName;
    }
	
	if ([elementName isEqualToString:@"html"]) {
		// probably html
		probablyPage = YES;		
	} else if ([elementName isEqualToString:@"rss"]) {
		// probably rss
		probablyFeed = YES;		
	} else if ([elementName isEqualToString:@"channel"]) {
		// starting rss feed
		self.dataString = [[[NSMutableString alloc] init] autorelease];
	} else if ([elementName isEqualToString:@"feed"]) {
		// probably atom
		probablyFeed = YES;
		// starting atom feed title
		self.dataString = [[[NSMutableString alloc] init] autorelease];
	} else if ( [elementName isEqualToString:@"link"]) {
		if ( probablyPage ) {
			if ( [[attributeDict objectForKey:@"rel"] rangeOfString: @"alt" options: NSCaseInsensitiveSearch].location != NSNotFound ) {
				if ( [[attributeDict objectForKey:@"type"] rangeOfString: @"xml" options: NSCaseInsensitiveSearch].location != NSNotFound ||
					[[attributeDict objectForKey:@"type"] rangeOfString: @"rss" options: NSCaseInsensitiveSearch].location != NSNotFound ||
					[[attributeDict objectForKey:@"type"] rangeOfString: @"atom" options: NSCaseInsensitiveSearch].location != NSNotFound ) {
					
					// get feed url from alt link
					self.feedURL = [NSURL URLWithString:[attributeDict objectForKey:@"href"] relativeToURL:self.feedURL];
					
					// stop parsing
					[parser abortParsing];
					
					// set fetch data flag
					shouldFetchUpdate = YES;
				}
			}
		}
	} else if ([elementName isEqualToString:@"item"]) {
		// starting new rss item
		self.newEntry = [NSMutableDictionary dictionary];
		parsingEntry = YES;
		NSLog(@"Start new RSS Item");
	} else if ([elementName isEqualToString:@"entry"]) {
		// starting new atom entry
		self.newEntry = [NSMutableDictionary dictionary];
		parsingEntry = YES;
		NSLog(@"Start new Atom Entry");
    } else if ([elementName isEqualToString:@"title"]) {
		// starting new title
		self.dataString = [NSMutableString string];
    } else if ([elementName isEqualToString:@"description"]) {
        // item description start
        self.dataString = [NSMutableString string];
    } else if ([elementName isEqualToString:@"content"]) {
		// entry content start
		self.dataString = [NSMutableString string];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {     
    if (qName) {
        elementName = qName;
    }
	
	if ( [elementName isEqualToString:@"item"]
		|| [elementName isEqualToString:@"entry"] ) {
		// add rss / atom item to list
		[self.newList addObject:self.newEntry];
		parsingEntry = NO;
    } else if ([elementName isEqualToString:@"title"]) {
        if ( parsingEntry ) {
			// entry item title end
			[self.newEntry setObject:self.dataString forKey:@"Title"];
		} else {
			// set feed title
			self.contentTitle = self.dataString;
		}
		self.dataString = nil;
    } else if ( [elementName isEqualToString:@"description"]
			   || [elementName isEqualToString:@"content"] ) {
        // item description / entry content end
        [self.newEntry setObject:self.dataString forKey:@"Body"];
		self.dataString = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ( self.dataString ) {
		[self.dataString appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	if ( self.newList && [self.newList count] > 0 ) {
		self.list = self.newList;
	} else if ( !shouldFetchUpdate ) {
		NSLog(@"About to Alert No Content");
		AlertWithMessage(@"No content found.");
	}
	
	NSLog(@"Document content indicates:");
	if ( probablyFeed ) {
		NSLog(@"Probably a Feed (RSS/Atom)");
	} else if ( probablyPage ) {
		NSLog(@"Probably a Web Page (HTML)");
	} else {
		NSLog(@"Still inconclusive.");
	}
	
	[parent dataRefreshed];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	// also called when we abort parsing
	NSLog(@"Parsing failed / aborted.");
	
	NSLog(@"Document content indicates:");
	if ( probablyFeed ) {
		NSLog(@"Probably a Feed (RSS/Atom)");
	} else if ( probablyPage ) {
		NSLog(@"Probably a Web Page (HTML)");
	} else {
		NSLog(@"Still inconclusive.");
	}
	
}


- (void)dealloc {
	self.list = nil;
	self.feedURL = nil;
	self.contentTitle = nil;
	
	self.receivedData = nil;
	self.newList = nil;
	self.newEntry = nil;
	self.dataString = nil;
	
    [super dealloc];
}

@end
