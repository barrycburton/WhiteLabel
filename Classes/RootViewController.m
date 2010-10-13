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
@synthesize refreshButton, loadingButton, loadingIndicator;


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
	[self setToolbarItems:[NSArray arrayWithObjects:self.refreshButton, nil] animated:NO];
	[self.loadingIndicator stopAnimating];
}

- (IBAction)changeSite {
	ChangeSiteViewController *changeSiteVC = [[[ChangeSiteViewController alloc] init] autorelease];
	changeSiteVC.parent = self;
	[changeSiteVC setText:[self getAddress]];
	[self.navigationController presentModalViewController:changeSiteVC animated:YES];
}

- (IBAction)refreshData {
	[self setToolbarItems:[NSArray arrayWithObjects:self.loadingButton, nil] animated:NO];
	[self.loadingIndicator startAnimating];
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
	
	self.loadingButton = [[[UIBarButtonItem alloc] initWithCustomView:self.loadingIndicator] autorelease];

	if ( self.feed.isUpdating ) {
		[self setToolbarItems:[NSArray arrayWithObjects:self.loadingButton, nil] animated:NO];
		[self.loadingIndicator startAnimating];
	} else {
		[self setToolbarItems:[NSArray arrayWithObjects:self.refreshButton, nil] animated:NO];
	}


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

