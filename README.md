# Wasteagram
Portfolio Project for Mobile Development CS 492
Implement Wasteagram, a mobile app that enables coffee shop employees to document daily food waste in the form of "posts" consisting of a photo, number of leftover items, the current date, and the location of the device when the post is created. The application should also display a list of all previous posts. After discussing the requirements with the client and sketching out the UX flow, your design notebook describes the app like this:

Wasteagram UX Flow 1Wasteagram UX Flow 2

Download full-size pdf Download Download full-size pdf

Here is a demonstration of a generic version of such an app:

Project 4 Wasteagram Demo

Download Larger Version

The functional requirements are:

Display a circular progress indicator when there are no previous posts to display in the List Screen.
The List Screen should display a list of all previous posts, with the most recent at the top of the list.
Each post in the List Screen should be displayed as a date, representing the date the post was created, and a number, representing the total number of wasted items recorded in the post.
Tapping on a post in the List Screen should cause a Detail Screen to appear. The Detail Screen's back button should cause the List Screen to appear.
The Detail Screen should display the post's date, photo, number of wasted items, and the latitude and longitude that was recorded as part of the post.
The List Screen should display a large button at the center bottom area of the screen.
Tapping on the large button enables an employee to capture a photo, or select a photo from the device's photo gallery.
After taking a new photo or selecting a photo from the gallery, the New Post screen appears.
The New Post screen displays the photo of wasted food, a Number of Items text input field for entering the number of wasted items, and a large upload button for saving the post.
Tapping on the Number of Items text input field should cause the device to display its numeric keypad.
In the New Post screen, tapping the back button in the app bar should cause the List Screen to appear.
In the New Post screen, tapping the large upload button should cause the List Screen to appear, with the latest post now appearing at the top of the list.
In the New Post screen, if the Number of Items field is empty, tapping the upload button should cause a sensible error message to appear.
In addition to the functional requirements above, your application should meet the following technical requirements:

Use the location, image_picker, cloud_firestore, and firebase_storage packages to meet the functional and technical requirements.
Incorporate the use of Firebase Cloud Storage and Firebase Cloud Firestore for storing images and post data.
Data should not be stored locally on the device.
On the List Screen, the application should display the posts stored in the Firestore database.
On the Detail Screen, the application should display the image stored in the Cloud Storage bucket.
On the New Post screen, tapping the large upload button should store a new post in the Firestore database.
Each "post" in Firestore should have the following attributes: date, imageURL, quantity, latitude and longitude.
The application should incorporate the Semantics widget in multiple places, such as interactive widgets like buttons, to aid accessibility.
The codebase should incorporate a model class.
The codebase should incorporate a few (two or three) simple unit tests that test the model class.
The functional and technical requirements specifically exercise the Exploration content and our module learning outcomes. In addition, here are some optional extra credit requirements that can add up to 4% to your overall class grade:

The app bar of the List Screen should display the total sum of the number of wasted items in all posts (extra 1% added to class grade)
Add integration tests that verify any one particular part of the UX flow (extra 1% added to class grade)
Integrate the use of in-app analytics (Analytics) to monitor application usage (extra 1% added to class grade)
Integrate the use of crash reporting (Sentry or Crashlytics) to record application crashes (extra 1% added to class grade)
