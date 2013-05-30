//
//  AddEditContactViewController.m
//  DatabasesWithFMDB
//
//  Created by Aron Crittendon on 5/22/13.
//  Copyright (c) 2013 Intouch Solutions. All rights reserved.
//

#import "AddEditContactViewController.h"

@interface AddEditContactViewController ()

@end

@implementation AddEditContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    editeMode = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.aeContact == nil) {
        self.aeContact = [Contact new];
    } else {
        [self setViewForEditMode];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setViewForEditMode {
    if (self.aeContact) {
        editeMode = YES;
        
        self.navigationItem.title = @"Edit Contact";
        
        self.nameField.text = self.aeContact.name;
        self.phoneField.text = self.aeContact.phone;
        self.emailField.text = self.aeContact.email;
        
        [self.saveButton setTitle:@"Update Contact" forState:UIControlStateNormal];
    } else {
        editeMode = NO;
    }
}

#pragma mark - IBActions

- (IBAction)saveBtnPressed:(id)sender {
    if (self.aeContact != nil) {
        if (!editeMode) {
            BOOL saveSuccesful = [[DataManager sharedDatabaseManager] saveNewContact:self.aeContact];
            if (saveSuccesful) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            BOOL updateSuccessful = [[DataManager sharedDatabaseManager] updateExistingContact:self.aeContact];
            if (updateSuccessful) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (IBAction)fieldUpdated:(UITextField*)updatedField {
    if (updatedField == self.nameField) {
        if (![self.nameField.text isEqualToString:@""]) {
            self.aeContact.name = self.nameField.text;
        }
    } else if (updatedField == self.phoneField) {
         self.aeContact.phone = self.phoneField.text;
    } else if (updatedField == self.emailField) {
         self.aeContact.email = self.emailField.text;
    }
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
