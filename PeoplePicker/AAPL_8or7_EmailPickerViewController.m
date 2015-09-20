/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    
                This view controller displays the people picker to pick a person with an email address when running on iOS 8.0 or earlier.
                Persons without an email address cannot be selected.
            
 */

#import "AAPL_8or7_EmailPickerViewController.h"
@import AddressBook;
@import AddressBookUI;


@interface AAPL_8or7_EmailPickerViewController () <ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end


@implementation AAPL_8or7_EmailPickerViewController
            
- (IBAction)showPicker:(id)sender
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    // The people picker will only display the person's name, image and email properties in ABPersonViewController.
    picker.displayedProperties = @[@(kABPersonEmailProperty)];
    
    if ([picker respondsToSelector:@selector(setPredicateForEnablingPerson:)])
    {
        // The people picker will enable selection of persons that have at least one email address.
        picker.predicateForEnablingPerson = [NSPredicate predicateWithFormat:@"emailAddresses.@count > 0"];
    }
        
    if ([picker respondsToSelector:@selector(setPredicateForSelectionOfPerson:)])
    {
        // The people picker will select a person that has exactly one email address and call peoplePickerNavigationController:didSelectPerson:,
        // otherwise the people picker will present an ABPersonViewController for the user to pick one of the email addresses.
        picker.predicateForSelectionOfPerson = [NSPredicate predicateWithFormat:@"emailAddresses.@count = 1"];
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark ABPeoplePickerNavigationControllerDelegate methods

// On iOS 8.0, a selected person is returned with this method.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    [self didSelectPerson:person identifier:kABMultiValueInvalidIdentifier];
}


// On iOS 8.0, a selected person and property is returned with this method.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self didSelectPerson:person identifier:identifier];
}


// On iOS 7.x or earlier, a selected person is returned with this method. This method may be deprecated in a future iOS 8.0 seed.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
#pragma clang diagnostic pop
{
    BOOL shouldContinue = NO;
    
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    if (emails)
    {
        if (ABMultiValueGetCount(emails) == 1)
        {
            ABMultiValueIdentifier identifier = ABMultiValueGetIdentifierAtIndex(emails, 0);
            [self didSelectPerson:person identifier:identifier];
            
            [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        }
        else if (CFArrayGetCount(emails) > 1)
        {
            // Show the person details for the user to pick which email address.
            shouldContinue = YES;
        }
        CFRelease(emails);
    }
    
    if (shouldContinue == NO)
    {
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    }
    
    return shouldContinue;
}


// On iOS 7.x or earlier, this method is required but never used by this sample. This method may be deprecated in a future iOS 8.0 seed.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
#pragma clang diagnostic pop
{
    [self didSelectPerson:person identifier:identifier];
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return NO;
}


// On iOS 7.x or earlier, this method is required and it must dismiss the picker. This method may be optional in a future iOS 8.0 seed.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    // Perform any additional work when the picker is cancelled by the user.
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
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

@end
