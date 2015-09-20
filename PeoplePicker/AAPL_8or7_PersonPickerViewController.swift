//
//  AAPL_8or7_PersonPickerViewController.swift
//  PeoplePicker
//
//  Translated by OOPer in cooperation with shlab.jp, on 2014/11/24.
//
//
/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information

    Abstract:

                The view controller class used for the third tab in our tab bar controller.

 */

import UIKit
import AddressBook
import AddressBookUI


@objc(AAPL_8or7_PersonPickerViewController)
class AAPL_8or7_PersonPickerViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate {
    
    
    @IBOutlet private weak var resultLabel: UILabel!
    
    
    @IBAction func showPicker(_: AnyObject) {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    //#MARK: ABPeoplePickerNavigationControllerDelegate methods
    
    // On iOS 8.0, a selected person is returned with this method.
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
        self.didSelectPerson(person)
    }
    
    
    // On iOS 7.x or earlier, a selected person is returned with this method. This method may be deprecated in a future iOS 8.0 seed.
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, shouldContinueAfterSelectingPerson person: ABRecord) -> Bool {
        self.didSelectPerson(person)
        
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
        return false
    }
    
    
    // On iOS 7.x or earlier, this method is required but never used by this sample. This method may be deprecated in a future iOS 8.0 seed.
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, shouldContinueAfterSelectingPerson person: ABRecord, property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
        return false
    }
    
    
    // On iOS 7.x or earlier, this method is required and it must dismiss the picker. This method may be optional in a future iOS 8.0 seed.
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController) {
        // Perform any additional work when the picker is cancelled by the user.
        
        peoplePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //#MARK: helper methods
    
    private func didSelectPerson(person: ABRecordRef) {
        var contactName: String? = ABRecordCopyCompositeName(person)?.takeRetainedValue() as String?
        contactName = contactName ?? "No Name"
        self.resultLabel.text = "Picked \(contactName!)"
    }
    
}