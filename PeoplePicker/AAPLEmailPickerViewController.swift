//
//  AAPLEmailPickerViewController.swift
//  PeoplePicker
//
//  Translated by OOPer in cooperation with shlab.jp, on 2014/11/24.
//
//
/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information

    Abstract:

                The view controller class used for the second tab in our tab bar controller.

 */

import UIKit
import AddressBook
import AddressBookUI


@objc(AAPLEmailPickerViewController)
class EmailPickerViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate {
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    @IBAction func showPicker(_: AnyObject) {
        // This example is to be run on iOS 8.0.
        guard #available(iOS 8.0, *) else {
            showVersionAlert()
            return
        }
        
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        
        // The people picker will only display the person's name, image and email properties in ABPersonViewController.
        picker.displayedProperties = [kABPersonEmailProperty as NSNumber]
        
        // The people picker will enable selection of persons that have at least one email address.
        picker.predicateForEnablingPerson = NSPredicate(format: "emailAddresses.@count > 0")
        
        // The people picker will select a person that has exactly one email address and call peoplePickerNavigationController:didSelectPerson:,
        // otherwise the people picker will present an ABPersonViewController for the user to pick one of the email addresses.
        picker.predicateForSelectionOfPerson = NSPredicate(format: "emailAddresses.@count = 1")
        
        self.present(picker, animated: true, completion: nil)
    }
    
    
    //#MARK: ABPeoplePickerNavigationControllerDelegate methods
    
    // A selected person is returned with this method.
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
        self.didSelectPerson(person, identifier: kABMultiValueInvalidIdentifier)
    }
    
    
    // A selected person and property is returned with this method.
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        self.didSelectPerson(person, identifier: identifier)
    }
    
    
    // Implement this if you want to do additional work when the picker is cancelled by the user. This method may be optional in a future iOS 8.0 seed.
    func peoplePickerNavigationControllerDidCancel(_ peoplePicker: ABPeoplePickerNavigationController) {
    }
    
    
    //#MARK: helper methods
    
    private func didSelectPerson(_ person: ABRecord, identifier: ABMultiValueIdentifier) {
        var emailAddress = "no email address"
        if let emails: ABMultiValue = ABRecordCopyValue(person, kABPersonEmailProperty)?.takeRetainedValue() as ABMultiValue? {
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
    
    
    private func showVersionAlert() {
        let alertView = UIAlertView(title: "Error", message: "This picker sample can only run\non iOS 8 or later.", delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
}
