//
//  ViewController.m
//  DatabasesWithFMDB
//
//  Created by Aron Crittendon on 5/21/13.
//  Copyright (c) 2013 Intouch Solutions. All rights reserved.
//

#import "ContactListViewController.h"
#import "AddEditContactViewController.h"
#import "ContactDetailsViewController.h"

@interface ContactListViewController ()

@end

@implementation ContactListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    dataMan = [DataManager sharedDatabaseManager];
    fetching = NO;
    
    [self.contactTable addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
//    for (int i = 0; i < 1000; i++) {
//        Contact *newContact = [Contact new];
//        newContact.name = [NSString stringWithFormat:@"John Doe %i", i];
//        newContact.phone = @"123-456-7890";
//        newContact.email = @"john.doe@email.com";
//        
//        [dataMan saveNewContact:newContact];
//    }
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    // NSLog(@"%@", [change description]);
    fetching = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextTwentyFiveFetched:) name:@"NextTwentyFiveFetched" object: nil];
    
    self.contactsArray = [NSMutableArray arrayWithArray:[dataMan fetchFirstTwentyFiveContacts]];
    [self.contactTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NextTwentyFiveFecthed" object:nil];
}

- (void)nextTwentyFiveFetched:(NSNotification*)notification{
    [self.contactTable reloadData];
    fetching = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)editBtnPressed:(id)sender {
    if (self.contactTable.isEditing) {
        [self.contactTable setEditing:NO animated:YES];
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
    } else {
        [self.contactTable setEditing:YES animated:YES];
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleDone;
        [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.contactsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // IMPORNTANT:  This example uses UITableViewCellStyleSubtitle vs. UITableViewCellStyleDefault
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.contactsArray objectAtIndex:indexPath.row] name];
    cell.detailTextLabel.text = [[self.contactsArray objectAtIndex:indexPath.row] phone];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedContact = [self.contactsArray objectAtIndex:indexPath.row];
    if (self.contactTable.isEditing) {
        [self performSegueWithIdentifier:@"AddEditContact" sender:self];
    } else {
        [self performSegueWithIdentifier:@"ViewContactDetail" sender:self];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)table commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BOOL deleteResult = [dataMan deleteContact:[self.contactsArray objectAtIndex:indexPath.row]];
        if (deleteResult) {
            self.contactsArray = [NSMutableArray arrayWithArray:[dataMan fetchAllContacts]];
            [self.contactTable reloadData];
        }
    }
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddEditContact"]) {
        AddEditContactViewController *addEditViewController = segue.destinationViewController;
        if (self.selectedContact) {
            addEditViewController.aeContact = self.selectedContact;
        }
    } else if ([segue.identifier isEqualToString:@"ViewContactDetail"]) {
        ContactDetailsViewController *detailViewController = segue.destinationViewController;
        if (self.selectedContact) {
            detailViewController.contact = self.selectedContact;
        }
    }
}

#pragma mark - UIScrollViewDelegate Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {    
    
    int totalHeight = [self.contactsArray count] * self.contactTable.rowHeight;
    
    int adjustedHeight = totalHeight - self.contactTable.frame.size.height - 25;
    
    if (scrollView.contentOffset.y >= adjustedHeight) {
        if (!fetching) {
            fetching = YES;
            
            dispatch_queue_t fetchQueue = dispatch_queue_create("fetch_message", NULL);
            dispatch_async(fetchQueue, ^{
                NSArray *nextTwentyFive = [dataMan fetchNextTwentyFiveContacts];
                [self.contactsArray addObjectsFromArray:nextTwentyFive];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NextTwentyFiveFetched" object:nil userInfo:nil];
                // [self.contactTable reloadData];
            });
        }
    }
    
    // NSLog(@"adjustedHeight: %i",adjustedHeight);
}

@end
