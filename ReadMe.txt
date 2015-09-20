PeoplePicker: Picking a Person or Property
===========================================================================

This sample demonstrates how to use the Address Book UI people picker and various properties like displayedProperties, predicateForEnablingPerson, and predicateForSelectionOfPerson. It shows how to browse a list of Address Book contacts to pick a person or to pick a person with an email address.

This sample also shows you how to use the people picker with the new 8.0 APIs and old 7.x APIs. This is useful for apps with a deployment target before 8.0.

Notes:
In iOS 8.0 the app using the people picker does not need access to the user’s contacts and the user will not be prompted for access.
If the app does not have access to the user's contacts a temporary copy of the selected person is returned from the poeple picker to the app.
If the app has access to the user's contacts the selected person is returned to the app from the people picker addressBook property.

===========================================================================
Using the Sample

This sample can be run on an iPhone or on the iPhone simulator. 

While looking over the source code of PeoplePicker you will find there is a separate view controller class for each sample:
AAPLPersonPickerViewController shows how to display the people picker to pick a person.
AAPLEmailPickerViewController shows how to display the people picker to pick a person with an email address.
AAPL_8or7_PersonPickerViewController shows how to display the people picker to pick a person when running on iOS 8.0 or earlier.
AAPL_8or7_EmailPickerViewController shows how to display the people picker to pick a person with an email address when running on iOS 8.0 or earlier.

===========================================================================
Build/Runtime Requirements

Building this sample requires Xcode 6.0 and iOS 8.0 SDK
Running the sample requires iOS 7.0 or later.

===========================================================================
Copyright (C) 2014 Apple Inc. All rights reserved.
