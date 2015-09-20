/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    
                This view controller displays the people picker to pick a person when running on iOS 8.0 or earlier.
            
 */

#import "AAPL_8or7_PersonPickerViewController.h"
@import AddressBook;
@import AddressBookUI;


@interface AAPL_8or7_PersonPickerViewController () <ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end


@implementation AAPL_8or7_PersonPickerViewController
            
- (IBAction)showPicker:(id)sender
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark ABPeoplePickerNavigationControllerDelegate methods

// On iOS 8.0, a selected person is returned with this method.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    [self didSelectPerson:person];
}


// On iOS 7.x or earlier, a selected person is returned with this method. This method may be deprecated in a future iOS 8.0 seed.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
#pragma clang diagnostic pop
{
    [self didSelectPerson:person];
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return NO;
}


// On iOS 7.x or earlier, this method is required but never used by this sample. This method may be deprecated in a future iOS 8.0 seed.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
#pragma clang diagnostic pop
{
    return NO;
}


// On iOS 7.x or earlier, this method is required and it must dismiss the picker. This method may be optional in a future iOS 8.0 seed.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    // Perform any additional work when the picker is cancelled by the user.
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark helper methods

- (void)didSelectPerson:(ABRecordRef)person
{
    NSString *contactName = CFBridgingRelease(ABRecordCopyCompositeName(person));
    self.resultLabel.text = [NSString stringWithFormat:@"Picked %@", contactName ? contactName : @"No Name"];
}

@end
