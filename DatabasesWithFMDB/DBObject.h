//
//  DBObject.h
//  DatabasesWithFMDB
//
//  Created by Thuy Copeland on 5/29/13.
//  Copyright (c) 2013 Intouch Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DBObject : NSObject

- (BOOL)runDMLQuery:(NSString*)query database:(FMDatabase*)database;

@end
