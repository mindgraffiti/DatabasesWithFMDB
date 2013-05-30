//
//  DBObject.m
//  DatabasesWithFMDB
//
//  Created by Thuy Copeland on 5/29/13.
//  Copyright (c) 2013 Intouch Solutions. All rights reserved.
//

#import "DBObject.h"

@implementation DBObject

#pragma mark Data Manipulation Langauge (DML) query convenience methods

// Used for running Insert/Update/Delete
- (BOOL)runDMLQuery:(NSString*)query database:(FMDatabase*)database {
    BOOL success = NO;
    if (query != nil && database != nil) {
        // Open the database
        [database open];
        
        // Execute Query and get result
        success = [database executeUpdate:query];
        
        // Close the database
        [database close];
        
    }
    return success;
}

@end
