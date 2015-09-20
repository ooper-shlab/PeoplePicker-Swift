/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    
                This view controller displays the people picker to pick a person.
            
 */

#import "AAPLPersonPickerViewController.h"
@import AddressBook;
@import AddressBookUI;


@interface AAPLPersonPickerViewController () <ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end


@implementation AAPLPersonPickerViewController
            
- (IBAction)showPicker:(id)sender
{
    // This example is to be run on iOS 8.0.
    if ([self isRunningOn8] == NO)
    {
        return;
    }
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark ABPeoplePickerNavigationControllerDelegate methods

// A selected person is returned with this method.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    NSString *contactName = CFBridgingRelease(ABRecordCopyCompositeName(person));
    self.resultLabel.text = [NSString stringWithFormat:@"Picked %@", contactName ? contactName : @"No Name"];
}


// Implement this if you want to do additional work when the picker is cancelled by the user. This method may be optional in a future iOS 8.0 seed.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
}


#pragma mark helper methods

- (BOOL)isRunningOn8
{
    BOOL result = YES;
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    if ([systemVersion compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)
    {
        result = NO;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"This picker sample can only run\non iOS 8 or later."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    return result;
}

@end
