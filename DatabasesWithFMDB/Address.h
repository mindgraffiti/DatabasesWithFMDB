//
//  Address.h
//  DatabasesWithFMDB
//
//  Created by Thuy Copeland on 5/29/13.
//  Copyright (c) 2013 Intouch Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface Address : NSObject

@property (strong, nonatomic) NSString *addressID;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zipcode;
@property (strong, nonatomic) NSDate *dateCreated;
@property (strong, nonatomic) NSDate *lastUpdated;

- (NSString *)selectByID;
- (NSString *)insertQuery;
- (NSString *)updateQuery;
- (NSString *)deleteQuery;

@end
