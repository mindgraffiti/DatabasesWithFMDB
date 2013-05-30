//
//  Contact.h
//  DatabasesWithFMDB
//
//  Created by Aron Crittendon on 5/21/13.
//  Copyright (c) 2013 Intouch Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Address.h"

@interface Contact : NSObject

@property (strong, nonatomic) NSString *contactID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSDate *dateCreated;
@property (strong, nonatomic) NSDate *lastUpdated;
@property (strong, nonatomic) Address *address;

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
