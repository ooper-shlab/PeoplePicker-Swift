/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    
                This view controller displays the people picker to pick a person with an email address.
                Persons without an email address cannot be selected.
            
 */

#import "AAPLEmailPickerViewController.h"
@import AddressBook;
@import AddressBookUI;


@interface AAPLEmailPickerViewController () <ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end


@implementation AAPLEmailPickerViewController
            
- (IBAction)showPicker:(id)sender
{
    // This example is to be run on iOS 8.0.
    if ([self isRunningOn8] == NO)
    {
        return;
    }
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    // The people picker will only display the person's name, image and email properties in ABPersonViewController.
    picker.displayedProperties = @[@(kABPersonEmailProperty)];
    
    // The people picker will enable selection of persons that have at least one email address.
    picker.predicateForEnablingPerson = [NSPredicate predicateWithFormat:@"emailAddresses.@count > 0"];
    
    // The people picker will select a person that has exactly one email address and call peoplePickerNavigationController:didSelectPerson:,
    // otherwise the people picker will present an ABPersonViewController for the user to pick one of the email addresses.
    picker.predicateForSelectionOfPerson = [NSPredicate predicateWithFormat:@"emailAddresses.@count = 1"];
    
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark ABPeoplePickerNavigationControllerDelegate methods

// A selected person is returned with this method.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    [self didSelectPerson:person identifier:kABMultiValueInvalidIdentifier];
}


// A selected person and property is returned with this method.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self didSelectPerson:person identifier:identifier];
}


// Implement this if you want to do additional work when the picker is cancelled by the user. This method may be optional in a future iOS 8.0 seed.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
}


#pragma mark helper methods

- (void)didSelectPerson:(ABRecordRef)person identifier:(ABMultiValueIdentifier)identifier
{
    NSString *emailAddress = @"no email address";
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    if (emails)
    {
        if (ABMultiValueGetCount(emails) > 0)
        {
            CFIndex index = 0;
            if (identifier != kABMultiValueInvalidIdentifier)
            {
                index = ABMultiValueGetIndexForIdentifier(emails, identifier);
            }
            emailAddress = CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, index));
        }
        CFRelease(emails);
    }
    
    self.resultLabel.text = [NSString stringWithFormat:@"Picked %@", emailAddress];
}


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
