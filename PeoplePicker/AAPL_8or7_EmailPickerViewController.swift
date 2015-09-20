//
//  AAPL_8or7_EmailPickerViewController.swift
//  PeoplePicker
//
//  Translated by OOPer in cooperation with shlab.jp, on 2014/11/24.
//
//
/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information

    Abstract:

                The view controller class used for the fourth tab in our tab bar controller.

 */

import UIKit
import AddressBook
import AddressBookUI


@objc(AAPL_8or7_EmailPickerViewController)
class AAPL_8or7_EmailPickerViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate {
    
    
    @IBOutlet private weak var resultLabel: UILabel!
    
    
    @IBAction func showPicker(AnyObject) {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        
        // The people picker will only display the person's name, image and email properties in ABPersonViewController.
        picker.displayedProperties = [NSNumber(int: kABPersonEmailProperty)]
        
        if picker.respondsToSelector("setPredicateForEnablingPerson:") {
            // The people picker will enable selection of persons that have at least one email address.
            picker.predicateForEnablingPerson = NSPredicate(format: "emailAddresses.@count > 0")
        }
        
        if picker.respondsToSelector("setPredicateForSelectionOfPerson:") {
            // The people picker will select a person that has exactly one email address and call peoplePickerNavigationController:didSelectPerson:,
            // otherwise the people picker will present an ABPersonViewController for the user to pick one of the email addresses.
            picker.predicateForSelectionOfPerson = NSPredicate(format: "emailAddresses.@count = 1")
        }
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    //#MARK: ABPeoplePickerNavigationControllerDelegate methods
    
    // On iOS 8.0, a selected person is returned with this method.
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!) {
        self.didSelectPerson(person, identifier: kABMultiValueInvalidIdentifier)
    }
    
    
    // On iOS 8.0, a selected person and property is returned with this method.
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        self.didSelectPerson(person, identifier: identifier)
    }
    
    
    // On iOS 7.x or earlier, a selected person is returned with this method. This method may be deprecated in a future iOS 8.0 seed.
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, shouldContinueAfterSelectingPerson person: ABRecord!) -> Bool {
        var shouldContinue = false
        
        if let emails: ABMultiValueRef = ABRecordCopyValue(person, kABPersonEmailProperty)?.takeRetainedValue() as ABMultiValueRef? {
            if ABMultiValueGetCount(emails) == 1 {
                let identifier = ABMultiValueGetIdentifierAtIndex(emails, 0)
                self.didSelectPerson(person, identifier: identifier)
                
                peoplePicker.dismissViewControllerAnimated(true, completion: nil)
            } else if ABMultiValueGetCount(emails) > 1 {    //###:CFArrayGetCount???
                // Show the person details for the user to pick which email address.
                shouldContinue = true
            }
        }
        
        if !shouldContinue {
            peoplePicker.dismissViewControllerAnimated(true, completion: nil)
        }
        
        return shouldContinue
    }
    
    
    // On iOS 7.x or earlier, this method is required but never used by this sample. This method may be deprecated in a future iOS 8.0 seed.
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, shouldContinueAfterSelectingPerson person: ABRecord!, property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
        self.didSelectPerson(person, identifier: identifier)
        
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
        return false
    }
    
    
    // On iOS 7.x or earlier, this method is required and it must dismiss the picker. This method may be optional in a future iOS 8.0 seed.
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
        // Perform any additional work when the picker is cancelled by the user.
        
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //#MARK: helper methods
    
    private func didSelectPerson(person: ABRecordRef, identifier: ABMultiValueIdentifier) {
        var emailAddress: String = "no email address"
        if let emails: ABMultiValueRef = ABRecordCopyValue(person, kABPersonEmailProperty)?.takeRetainedValue() as ABMultiValueRef? {
            if ABMultiValueGetCount(emails) > 0 {
                var index: CFIndex = 0
                if identifier != kABMultiValueInvalidIdentifier {
                    index = ABMultiValueGetIndexForIdentifier(emails, identifier)
                }
                emailAddress = ABMultiValueCopyValueAtIndex(emails, index).takeRetainedValue() as! String
            }
        }
        
        self.resultLabel.text = "Picked \(emailAddress)"
    }
    
}