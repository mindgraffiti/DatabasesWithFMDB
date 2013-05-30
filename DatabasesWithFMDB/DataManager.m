//
//  DataManager.m
//  DatabasesWithFMDB
//
//  Created by Aron Crittendon on 5/21/13.
//  Copyright (c) 2013 Intouch Solutions. All rights reserved.
//

#import "DataManager.h"
#import "FMDatabase.h"

DataManager *dbMan;
static NSString *dbFileName = @"database.sqlite";

@implementation DataManager

+ (id)sharedDatabaseManager {
	@synchronized(self){
		if (dbMan == nil) {
			dbMan = [[super alloc] init];
		}
	}
	return dbMan;
}

- (id)init {
    self = [super init];
    if (self) {
        //[self checkAndCreateDatabase];
    }
    return self;
}

- (void)checkAndCreateDatabase {
    BOOL success;
    
    // Get the path to the documents directory and append the databaseName
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:dbFileName];
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
	
    // Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:dbPath];
	
    if(success) {
        // If file exists, then no action is required.
    } else {
        // Get the path to the database in the application package
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbFileName];
        
        // Copy the database from the package to the users filesystem
        [fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
        
        NSLog(@"Finished Copying from %@ to %@", databasePathFromApp, dbPath);
    }
    
    self.database = [FMDatabase databaseWithPath:dbPath];
}

- (NSString *)getNewUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

- (Contact*)fetchContactWithID:(NSString*)contactID {
    // Create result
    Contact *result = nil;
    
    // If contactID is not nil, then query database for contact
    if (contactID != nil) {
        result = [Contact fetchContactByID:contactID dataBase:self.database];
    }
    
    // Return
    return result;
}

- (NSArray*)fetchFirstTwentyFiveContacts {
    // Query the database for all contacts and return as result array.
    NSArray *result = [Contact fetchFirstTwentyFive:self.database];
    
    self.lastFetchedContact = [result objectAtIndex:[result count] -1];
    // Return
    return result;
}

- (NSArray*)fetchNextTwentyFiveContacts{
    // Query the database for all contacts and return as result array.
    NSArray *result = [self.lastFetchedContact fetchNextTwentyFive:self.database];
    
    self.lastFetchedContact = [result objectAtIndex:[result count] -1];
    // Return
    return result;

}

- (NSArray*)fetchAllContacts {
    // Query the database for all contacts and return as result array.
    NSArray *result = [Contact fetchAllContacts:self.database];
    
    // Return
    return result;
}

- (BOOL)saveNewContact:(Contact*)newContact {
    BOOL saved = NO;
    
    if (newContact != nil) {
        // Get UUID for newContact
        newContact.contactID = [self getNewUUID];
        
        // Set DateCreated and LastUpdated
        newContact.dateCreated = [NSDate date];
        newContact.lastUpdated = [NSDate date];
        
        // save newContect and set saved boolean based on result
        saved = [newContact insert:self.database];
    }
    
    // Return
    return saved;
}

- (BOOL)updateExistingContact:(Contact*)existingContact {
    BOOL updated = NO;
    
    if (existingContact != nil) {
        // Set LastUpdated
        existingContact.lastUpdated = [NSDate date];
        
        // update existingContact and set updated boolean based on result
        updated = [existingContact update:self.database];
    }
    
    // Return
    return updated;
}

- (BOOL)deleteContact:(Contact*)contactToDelete {
    BOOL deleted = NO;
    
    if (contactToDelete != nil) {
        // delete contactToDelete and set updated boolean based on result
        deleted = [contactToDelete delete:self.database];
    }
    
    // Return
    return deleted;
}

@end
