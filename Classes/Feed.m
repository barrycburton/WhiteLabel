//
//  Feed.m
//  WhiteLabel
//
//  Created by Barry Burton on 10/7/10.
//  Copyright 2010 Fonetik. All rights reserved.
//

#import "RootViewController.h"
#import "Feed.h"
#import "NetworkActivity.h"
#import "AlertViews.h"
#import "NSURL+MD5.h"
#import <objc/runtime.h>

@implementation Feed

@synthesize list, feedURL, contentTitle, parent;
@synthesize receivedData, newList, newEntry, dataString;
@synthesize lastUpdated;
@synthesize isUpdating;

static char entryKey;


- (id)initWithParent:(RootViewController *)theParent {
    if ( (self = [super init]) ) {
		self.list = [[[NSArray alloc] init] autorelease];
		parsingEntry = NO;
		self.feedURL = nil;
		self.parent = theParent;
		[self setAddress:[[NSUserDefaults standardUserDefaults] objectForKey:@"dataURL"]];
		self.contentTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"dataTitle"];
		self.list = [[NSUserDefaults standardUserDefaults] objectForKey:@"dataList"];
		self.lastUpdated = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdated"];
    }
    return self;
}

- (void)setAddress:(NSString*)theAddress {
	if ( theAddress ) {
		if ( ![theAddress hasPrefix: @"http://" ] && ![theAddress hasPrefix: @"https://" ] ) {
			theAddress = [@"http://" stringByAppendingString:theAddress];
		}
		self.feedURL = [NSURL URLWithString:theAddress];
	}
}

- (NSString *)getAddress {
	return [self.feedURL absoluteString];
}

- (NSString *)getTitle {
	return self.contentTitle;
}

- (unsigned)countOfList {
	return [self.list count];
}

- (id)objectInListAtIndex:(unsigned)theIndex {
    return [self.list objectAtIndex:theIndex];
}


- (void)fetchUpdatedData {
	isUpdating = YES;
	
	if ( shouldFetchUpdate ) {
		shouldFetchUpdate = NO;
	} else {
		[[NetworkActivity sharedNetworkActivity] operationStarted];
	}
	
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
		self.feedURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"dataURL"]];
		isUpdating = NO;
		[[NetworkActivity sharedNetworkActivity] operationEnded];
		[parent dataWasRefreshed];
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
	

	NSString *contentType = nil;
	if ( probablyFeed ) {
		contentType = @"Probably a Feed (RSS/Atom)";
	} else if ( probablyPage ) {
		contentType = @"Probably a Web Page (HTML)";
	} else {
		contentType = @"Nothing, yet";
	}
	NSLog(@"MIME Type indicates: %@", contentType);
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    /* Append the new data to the received data. */
    [self.receivedData appendData:data];
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Connection started but failed later.");
	AlertWithError(error);
	[connection release];
	self.feedURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"dataURL"]];
	isUpdating = NO;
	[[NetworkActivity sharedNetworkActivity] operationEnded];
	[parent dataWasRefreshed];
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
	if ( parseError ) {
		NSString *parseErrorDescription = [parseError description];
		if ( parseErrorDescription ) {
			NSLog(@"Parse Error: %@", parseErrorDescription);
		}
	}
	
	[parser release];
	
	NSLog(@"Done with parsing");

	if ( !shouldFetchUpdate ) {
		if ( self.newList && [self.newList count] > 0 ) {
			self.list = self.newList;
			self.lastUpdated = [NSDate date];
			
			[[NSUserDefaults standardUserDefaults] setObject:[self getAddress] forKey:@"dataURL"];
			[[NSUserDefaults standardUserDefaults] setObject:self.contentTitle forKey:@"dataTitle"];
			[[NSUserDefaults standardUserDefaults] setObject:self.list forKey:@"dataList"];
			[[NSUserDefaults standardUserDefaults] setObject:self.lastUpdated forKey:@"lastUpdated"];
			[[NSUserDefaults standardUserDefaults] synchronize];
            
            for ( NSDictionary *entry in self.list ) {
                NSString *htmlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL];
                htmlString = [NSString stringWithFormat:@"<html><body>%@</body></html>", [entry objectForKey:@"Body"]];
                UIWebView *tempWebView = [[UIWebView alloc] init];
                [tempWebView setDelegate:self];
                objc_setAssociatedObject(tempWebView, &entryKey, entry, OBJC_ASSOCIATION_RETAIN);
                [tempWebView loadHTMLString:htmlString baseURL:nil];
            }
            
            
		} else {
			NSLog(@"About to Alert No Content");
			AlertWithMessage(@"No content found.");
			self.feedURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"dataURL"]];
		}
	}
	
	NSString *contentType = nil;
	if ( probablyFeed ) {
		contentType = @"Probably a Feed (RSS/Atom)";
	} else if ( probablyPage ) {
		contentType = @"Probably a Web Page (HTML)";
	} else {
		contentType = @"Still inconclusive.";
	}
	NSLog(@"Document content indicates: %@", contentType);
	
	self.receivedData = nil;
	self.newList = nil;
	self.newEntry = nil;
	self.dataString = nil;
	
	if ( shouldFetchUpdate ) {
		[self fetchUpdatedData];
	} else {
		isUpdating = NO;
		[[NetworkActivity sharedNetworkActivity] operationEnded];
		[parent dataWasRefreshed];
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
	NSLog(@"Parsing ended");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	// also called when we abort parsing
	NSLog(@"Parsing failed / aborted.");
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSOperationQueue *downloader = [[NSOperationQueue alloc] init];
    int count = [[webView stringByEvaluatingJavaScriptFromString:@"document.images.length"] intValue];
    for ( int i = 0; i < count; i++ ) {
        NSURL *imageURL = [NSURL URLWithString:[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.images[%d].src", i]]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"images"];
        NSString *fileExtension = [[NSString stringWithFormat:@"/%@", [imageURL lastPathComponent]] pathExtension];
        NSLog(@"File extension %@", fileExtension);
        if ( !fileExtension ) {
            fileExtension = @"jpg";
        }
        NSString *fileName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", [imageURL hexadecimalMD5Value], fileExtension]];
        NSString *relativeName = [@"images" stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", [imageURL hexadecimalMD5Value], fileExtension]];
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.images[%d].src = \"%@\"", i, relativeName]];
        
        [downloader addOperationWithBlock:^(void) {
            NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
            [imageData writeToFile:fileName atomically:NO];
            NSLog(@"Wrote file: %@", fileName);
        }];
    }
    NSString *newBody = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSLog(@"New Body: %@", newBody);
    NSMutableDictionary *entry = (NSMutableDictionary *)objc_getAssociatedObject(webView, &entryKey);
    [entry setObject:newBody forKey:@"Body"];
    [[NSUserDefaults standardUserDefaults] setObject:self.list forKey:@"dataList"];
    [webView release];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [webView release];
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
