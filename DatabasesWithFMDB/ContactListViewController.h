//
//  ViewController.h
//  DatabasesWithFMDB
//
//  Created by Aron Crittendon on 5/21/13.
//  Copyright (c) 2013 Intouch Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "DataManager.h"

@interface ContactListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    DataManager *dataMan;
    BOOL fetching;
}

@property (nonatomic, retain) NSMutableArray *contactsArray;
@property (nonatomic, retain) IBOutlet UITableView *contactTable;
@property (nonatomic, retain) Contact *selectedContact;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
- (void)nextTwentyFiveFetched:(NSNotification*)notification;
@end
