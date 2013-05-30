//
//  AddEditContactViewController.h
//  DatabasesWithFMDB
//
//  Created by Aron Crittendon on 5/22/13.
//  Copyright (c) 2013 Intouch Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Contact.h"

@interface AddEditContactViewController : UIViewController <UITextFieldDelegate> {
    BOOL editeMode;
}

@property (nonatomic, strong) Contact *aeContact;

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UITextField *phoneField;
@property (nonatomic, strong) IBOutlet UITextField *emailField;
@property (nonatomic, strong) IBOutlet UIButton *saveButton;

- (IBAction)saveBtnPressed:(id)sender;
- (void)setViewForEditMode;
- (IBAction)fieldUpdated:(UITextField*)updatedField;


@end
