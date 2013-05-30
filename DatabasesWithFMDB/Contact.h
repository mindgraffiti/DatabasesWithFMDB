//
//  Contact.h
//  DatabasesWithFMDB
//
//  Created by Aron Crittendon on 5/21/13.
//  Copyright (c) 2013 Intouch Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface Contact : NSObject

@property (nonatomic, retain) NSString *contactID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSDate *dateCreated;
@property (nonatomic, retain) NSDate *lastUpdated;

+ (NSString*)selectAllQuery;
+ (NSString*)selectByIDQuery:(NSString*)cID;
- (NSString*)insertQuery;
- (NSString*)updateQuery;
- (NSString*)deleteQuery;

+ (NSString*)selectFirstTwentyFive;
- (NSString*)selectNextTwentyFive;
+ (NSArray*)fetchFirstTwentyFive:(FMDatabase*)database;
- (NSArray*)fetchNextTwentyFive:(FMDatabase*)database;
+ (NSArray*)fetchAllContacts:(FMDatabase*)database;
+ (Contact*)fetchContactByID:(NSString*)cID dataBase:(FMDatabase*)database;

- (BOOL)insert:(FMDatabase*)database;
- (BOOL)update:(FMDatabase*)database;
- (BOOL)delete:(FMDatabase*)database;

@end
