//
//  ContactDetailsViewController.h
//  DatabasesWithFMDB
//
//  Created by Aron Crittendon on 5/25/13.
//  Copyright (c) 2013 Intouch Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface ContactDetailsViewController : UIViewController

@property (nonatomic, strong) Contact *contact;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberLabel;
@property (nonatomic, strong) IBOutlet UILabel *emailLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateCreatedLabel;
@property (nonatomic, strong) IBOutlet UILabel *lastUpdatedLabel;

@end
