//
//  RootViewController.m
//  White Label
//
//  Created by Barry Burton on 9/19/10.
//  Copyright Fonetik 2010. All rights reserved.
//

#import "RootViewController.h"
#import "ChangeSiteViewController.h"

@implementation RootViewController

@synthesize rootTableView, webViewController, feed;
@synthesize refreshButton, flexibleSpaceButton, fixedSpaceButton;
@synthesize loadingButton, loadingIndicator, lastUpdatedButton, lastUpdatedDate;


- (void)configureToolbar:(BOOL)isLoading {
	NSString *dateString;
	if ( self.feed.lastUpdated ) {
		NSDateFormatterStyle dateStyle;
		
		NSCalendar *cal = [NSCalendar currentCalendar];
		NSDateComponents *components = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
		NSDate *today = [cal dateFromComponents:components];
		components = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self.feed.lastUpdated];
		NSDate *lastUpdatedDay = [cal dateFromComponents:components];
		
		if([today isEqualToDate:lastUpdatedDay]) {
			dateStyle = NSDateFormatterNoStyle;
		} else {
			dateStyle = NSDateFormatterShortStyle;
		}
		dateString = [NSDateFormatter localizedStringFromDate:self.feed.lastUpdated dateStyle:dateStyle timeStyle:NSDateFormatterShortStyle];
	} else {
		dateString = @"-";
	}
	self.lastUpdatedDate.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Updated", @"UpdatedKey"), dateString];
	[self.lastUpdatedDate sizeToFit];
	
	if ( isLoading ) {
		[self setToolbarItems:[NSArray arrayWithObjects:self.loadingButton, self.flexibleSpaceButton, self.lastUpdatedButton, self.flexibleSpaceButton, self.fixedSpaceButton, nil] animated:NO];
		[self.loadingIndicator startAnimating];
	} else {
		[self setToolbarItems:[NSArray arrayWithObjects:self.refreshButton, self.flexibleSpaceButton, self.lastUpdatedButton, self.flexibleSpaceButton, self.fixedSpaceButton, nil] animated:NO];
		[self.loadingIndicator stopAnimating];
	}
}

- (void)loadAddress:(NSString *)address {
	NSLog(@"Loading address %@", address);
	
	[self.feed setAddress:address];
	
	[self refreshData];
	
	[[NSUserDefaults standardUserDefaults] setObject:address forKey:@"savedAddress"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getAddress {
	return [self.feed getAddress];
}

- (void)dataWasRefreshed {
	[(UITableView *)self.view reloadData];
	self.title = self.feed.contentTitle;
	[self configureToolbar:NO];
}

- (IBAction)changeSite {
	ChangeSiteViewController *changeSiteVC = [[[ChangeSiteViewController alloc] init] autorelease];
	changeSiteVC.parent = self;
	[changeSiteVC setText:[self getAddress]];
	[self.navigationController presentModalViewController:changeSiteVC animated:YES];
}

- (IBAction)refreshData {
	[self configureToolbar:YES];
	[self.feed fetchUpdatedData];
}

- (Feed *)feed {
	if ( !feed ) {
		feed = [[Feed alloc] initWithParent:self];
	}
	return feed;
}

#pragma mark -
#pragma mark View lifecycle


- (id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	
	return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.refreshButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)] autorelease];
	
	self.loadingIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
	self.loadingIndicator.frame = CGRectMake(0, 0, 19, 19);
	self.loadingButton = [[[UIBarButtonItem alloc] initWithCustomView:self.loadingIndicator] autorelease];
	
	self.lastUpdatedDate = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	self.lastUpdatedDate.numberOfLines = 1;
	self.lastUpdatedDate.textAlignment = UITextAlignmentCenter;
	self.lastUpdatedDate.adjustsFontSizeToFitWidth = NO;
	self.lastUpdatedDate.font = [UIFont systemFontOfSize:12];
	self.lastUpdatedDate.textColor = [UIColor whiteColor];
	self.lastUpdatedDate.backgroundColor = [UIColor clearColor];
	self.lastUpdatedButton = [[[UIBarButtonItem alloc] initWithCustomView:self.lastUpdatedDate] autorelease];

	self.flexibleSpaceButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];

	self.fixedSpaceButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
	self.fixedSpaceButton.width = 45;
	
	[self configureToolbar:self.feed.isUpdating];

	// Uncomment the following line to set the navigation bar title to the app name for this view controller.
	// self.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ( feed ) {
		return [feed countOfList];
	} else {
		return 0;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	NSDictionary *itemAtIndex = (NSDictionary *)[feed objectInListAtIndex:indexPath.row];
    cell.textLabel.text = [itemAtIndex objectForKey:@"Title"];

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *itemAtIndex = (NSDictionary *)[feed objectInListAtIndex:indexPath.row];
	NSString *title = [itemAtIndex objectForKey:@"Title"];
	NSString *body = [itemAtIndex objectForKey:@"Body"];
	 
	if ( !self.webViewController ) {
		self.webViewController = [[[WebViewController alloc] init] autorelease];
	}
		
	[self.webViewController setURL:feed.feedURL andTitle:title andHTML:body];
	[self.navigationController pushViewController:self.webViewController animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.rootTableView = nil;
	self.webViewController = nil;
}

- (void)dealloc {
	self.rootTableView = nil;
	self.webViewController = nil;
	self.feed = nil;
    [super dealloc];
}


@end

