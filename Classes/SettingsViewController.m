//
//  SettingsViewController.m
//  WhiteLabel
//
//  Created by Barry Burton on 10/8/10.
//  Copyright 2010 Fonetik. All rights reserved.
//

#import "SettingsViewController.h"
#import "RootViewController.h"

@implementation SettingsViewController

@synthesize parent, initialText;
@synthesize tableView, textField;


#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
	// Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
	if ((self = [super initWithStyle:style])) {
	}
	return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.tableView.allowsSelection = NO;
	
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
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Site";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *CellIdentifier;
	UITableViewCell *cell;
	
	if ( [indexPath row] == 0 ) {
		CellIdentifier = @"staticCell";
		cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		}
		
		// Configure the cell...
		cell.textLabel.text = @"Title";
		cell.detailTextLabel.text = [parent getTitle];
	} else {
		CellIdentifier = @"editableCell";
		cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];

			// TODO this should really just be a TableViewCell subclass...
			self.textField = [[[UITextField alloc] initWithFrame:CGRectMake(83, 12, 207, 19)] autorelease];
			self.textField.delegate = self;
			self.textField.font = [UIFont boldSystemFontOfSize:14];
			self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
			
			[cell.contentView insertSubview:self.textField aboveSubview:cell.detailTextLabel];
			detailTextLabel = cell.detailTextLabel;
		}
		
		// Configure the cell...
		cell.textLabel.text = @"Address";
		self.textField.text = [parent getAddress];
		[self.textField becomeFirstResponder];
	}
    
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
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textField) {
		[self acceptAction:self.textField];
    }
    return YES;
}

- (IBAction)acceptAction:(id)sender {
	self.initialText = textField.text;
	[self.parent loadAddress:textField.text];
	[self.textField resignFirstResponder];
	[self.parent dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelAction:(id)sender {
	[self.textField resignFirstResponder];
	[self.parent dismissModalViewControllerAnimated:YES];
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
}


- (void)dealloc {
	self.textField = nil;
	self.parent = nil;
	self.initialText = nil;
    [super dealloc];
}

@end
