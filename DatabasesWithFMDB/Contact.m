//
//  Contact.m
//  DatabasesWithFMDB
//
//  Created by Aron Crittendon on 5/21/13.
//  Copyright (c) 2013 Intouch Solutions. All rights reserved.
//

#import "Contact.h"

@implementation Contact

#pragma mark - Set Contact with FMResultSet

- (void)populateWithFMResultSet:(FMResultSet*)resultSet {
    self.contactID = [resultSet stringForColumn:@"ContactID"];
    self.name = [resultSet stringForColumn:@"Name"];
    self.phone = [resultSet stringForColumn:@"Phone"];
    self.email = [resultSet stringForColumn:@"Email"];
    
    NSString *dateCreatedStr = [resultSet stringForColumn:@"DateCreated"];
    NSString *lastUpdatedStr = [resultSet stringForColumn:@"LastUpdated"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    self.dateCreated = [df dateFromString:dateCreatedStr];
    self.lastUpdated = [df dateFromString:lastUpdatedStr];
}

#pragma mark - Query Convenience Methods

+ (NSString*)selectFirstTwentyFive{
    return @"SELECT * FROM Contacts ORDER BY LastUpdated DESC LIMIT 25";
}

- (NSString*)selectNextTwentyFive{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *lastUpdatedStr = [df stringFromDate:self.lastUpdated];
    
    return [NSString stringWithFormat:@"SELECT * FROM Contacts WHERE LastUpdated < '%@' ORDER BY LastUpdated DESC LIMIT 25", lastUpdatedStr];
}

+ (NSString*)selectAllQuery {
    return @"SELECT * FROM Contacts ORDER BY LastUpdated DESC";
}

+ (NSString*)selectByIDQuery:(NSString*)cID {
    return [NSString stringWithFormat:@"SELECT * FROM Contacts WHERE ContactID = '%@'", cID];
}

- (NSString*)insertQuery {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: @"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSString *dateAddedStr = [df stringFromDate:self.dateCreated];
    NSString *lastUpdatedStr = [df stringFromDate:self.lastUpdated];
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO Contacts (ContactID, Name, Phone, Email, DateCreated, LastUpdated) VALUES ('%@', '%@', '%@', '%@', '%@', '%@')", self.contactID, self.name, self.phone, self.email, dateAddedStr, lastUpdatedStr];
    
    return query;
}

- (NSString*)updateQuery {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: @"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSString *lastUpdatedStr = [df stringFromDate:self.lastUpdated];
    
    NSString *query = [NSString stringWithFormat:@"UPDATE Contacts SET Name = '%@', Phone = '%@', Email = '%@', LastUpdated = '%@' WHERE ContactID = '%@'", self.name, self.phone, self.email, lastUpdatedStr, self.contactID];
    
    return query;
}

- (NSString*)deleteQuery {
    return [NSString stringWithFormat:@"DELETE FROM Contacts WHERE ContactID = '%@'", self.contactID];
}

#pragma mark - fetch methods

+ (NSArray*)fetchFirstTwentyFive:(FMDatabase*)database{
    NSMutableArray *results = [NSMutableArray new];
    
    if (database != nil) {
        // Open the Database
        [database open];
        
        // Get the query string
        NSString *query = [self selectFirstTwentyFive];
        
        // Execute the query & get results
        FMResultSet *fetchResults = [database executeQuery:query];
        
        // Iterate through the results
        while ([fetchResults next]) {
            // Create contact
            Contact *fetchedContact = [Contact new];
            
            // Populate with result
            [fetchedContact populateWithFMResultSet:fetchResults];
            
            // Add contact to results array
            [results addObject:fetchedContact];
        }
        
        // Close the database
        [database close];
    }
    return results;
}


- (NSArray*)fetchNextTwentyFive:(FMDatabase*)database;{
    NSMutableArray *results = [NSMutableArray new];
    
    if (database != nil) {
        // Open the Database
        [database open];
        
        // Get the query string
        NSString *query = [self selectNextTwentyFive];
        
        // Execute the query & get results
        FMResultSet *fetchResults = [database executeQuery:query];
        
        // Iterate through the results
        while ([fetchResults next]) {
            // Create contact
            Contact *fetchedContact = [Contact new];
            
            // Populate with result
            [fetchedContact populateWithFMResultSet:fetchResults];
            
            // Add contact to results array
            [results addObject:fetchedContact];
        }
        
        // Close the database
        [database close];
    }
    return results;
}
+ (NSArray*)fetchAllContacts:(FMDatabase*)database {
    NSMutableArray *results = [NSMutableArray new];
    
    if (database != nil) {
        // Open the Database
        [database open];
        
        // Get the query string
        NSString *query = [Contact selectAllQuery];
        
        // Execute the query & get results
        FMResultSet *fetchResults = [database executeQuery:query];
        
        // Iterate through the results
        while ([fetchResults next]) {
            // Create contact
            Contact *fetchedContact = [Contact new];
            
            // Populate with result
            [fetchedContact populateWithFMResultSet:fetchResults];
            
            // Add contact to results array
            [results addObject:fetchedContact];
        }
        
        // Close the database
        [database close];
    }
    return results;
}

+ (Contact*)fetchContactByID:(NSString*)cID dataBase:(FMDatabase*)database {
    Contact *fetchedContact = [Contact new];
    
    if (database != nil) {
        // Open the Database
        [database open];
        
        // Get the query string
        NSString *query = [Contact selectByIDQuery:cID];
        
        // Execute the query & get results
        FMResultSet *fetchResults = [database executeQuery:query];

        while ([fetchResults next]) {
            // Populate with result
            [fetchedContact populateWithFMResultSet:fetchResults];
        }
        
        // Close the database
        [database close];
    }
    return fetchedContact;
}

#pragma mark insert/update methods

- (BOOL)insert:(FMDatabase*)database {
    BOOL inserted = NO;
    
    // Get the query string
    NSString *query = [self insertQuery];
    
    // Run the query
    inserted = [self runDMLQuery:query database:database];
    
    // Return result
    return inserted;
}

- (BOOL)update:(FMDatabase*)database {
    BOOL updated = NO;
    
    // Get the query string
    NSString *query = [self updateQuery];
    
    // Run the query
    updated = [self runDMLQuery:query database:database];
    
    // Return result
    return updated;
}

#pragma mark delete method

- (BOOL)delete:(FMDatabase*)database {
    BOOL deleted = NO;
    
    // Get the query string
    NSString *query = [self deleteQuery];
    
    // Run the query
    deleted = [self runDMLQuery:query database:database];
    
    // Return result
    return deleted;
}

    
@end
