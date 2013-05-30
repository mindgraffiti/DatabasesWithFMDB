//
//  DataManager.h
//  DatabasesWithFMDB
//
//  Created by Aron Crittendon on 5/21/13.
//  Copyright (c) 2013 Intouch Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"
#import "FMDatabase.h"

@interface DataManager : NSObject

@property (strong, nonatomic) FMDatabase *database;
@property (strong, nonatomic) Contact *lastFetchedContact;

+ (id)sharedDatabaseManager;

- (void)checkAndCreateDatabase;
- (NSString *)getNewUUID;

- (Contact*)fetchContactWithID:(NSString*)contactID;
- (NSArray*)fetchAllContacts;
- (NSArray*)fetchFirstTwentyFiveContacts;
- (NSArray*)fetchNextTwentyFiveContacts;
- (BOOL)saveNewContact:(Contact*)newContact;
- (BOOL)updateExistingContact:(Contact*)existingContact;
- (BOOL)deleteContact:(Contact*)contactToDelete;

@end
