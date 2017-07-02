//
//  AAPLPersonPickerViewController.swift
//  PeoplePicker
//
//  Translated by OOPer in cooperation with shlab.jp, on 2014/11/24.
//
//
/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information

    Abstract:

                The view controller class used for the first tab in our tab bar controller.

 */

import UIKit
import AddressBook
import AddressBookUI


@objc(AAPLPersonPickerViewController)
class PersonPickerViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate {
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    @IBAction func showPicker(_: AnyObject) {
        // This example is to be run on iOS 8.0.
        guard #available(iOS 8.0, *) else {
            showVersionAlert()
            return
        }
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        
        self.present(picker, animated: true, completion: nil)
    }
    
    
    //#MARK: ABPeoplePickerNavigationControllerDelegate methods
    
    // A selected person is returned with this method.
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
        var contactName = ABRecordCopyCompositeName(person)?.takeRetainedValue() as String?
        contactName = contactName ?? "No Name"
        self.resultLabel.text = "Picked \(contactName!)"
    }
    
    
    // Implement this if you want to do additional work when the picker is cancelled by the user. This method may be optional in a future iOS 8.0 seed.
    func peoplePickerNavigationControllerDidCancel(_ peoplePicker: ABPeoplePickerNavigationController) {
    }
    
    
    //#MARK: helper methods
    
    private func showVersionAlert() {
        let alertView = UIAlertView(title: "Error", message: "This picker sample can only run\non iOS 8 or later.", delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
}
