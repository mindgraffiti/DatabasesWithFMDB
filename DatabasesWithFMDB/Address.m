//
//  Address.m
//  DatabasesWithFMDB
//
//  Created by Thuy Copeland on 5/29/13.
//  Copyright (c) 2013 Intouch Solutions. All rights reserved.
//

#import "Address.h"

@implementation Address

- (NSString*)selectByID {
    return [NSString stringWithFormat:@"SELECT * FROM Adress WHERE AddressID = '%@'",self.addressID];
}

- (NSString*)insertQuery {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: @"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSString *dateAddedStr = [df stringFromDate:self.dateCreated];
    NSString *lastUpdatedStr = [df stringFromDate:self.lastUpdated];
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO Address (AddressID, Street, City, State, ZipCode, DateCreated, LastUpdated) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@')", self.addressID, self.street, self.city, self.state, self.zipcode,  dateAddedStr, lastUpdatedStr];
    
    return query;
}

- (NSString*)updateQuery {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: @"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSString *lastUpdatedStr = [df stringFromDate:self.lastUpdated];
    
    NSString *query = [NSString stringWithFormat:@"UPDATE Address SET Street = '%@', City = '%@', State = '%@', ZipCode = '%@', LastUpdated = '%@' WHERE AddressID = '%@'", self.street, self.city, self.state, self.zipcode, lastUpdatedStr, self.addressID];
    
    return query;
}

- (NSString*)deleteQuery {
    return [NSString stringWithFormat:@"DELETE FROM Address WHERE AddressID = '%@'", self.addressID];
}



@end
