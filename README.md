# Flutter + Firebase = AWESOME!

This is a simple public chat app to demonstrate how to integrate Firebase project into Flutter app. 

The project has only 2 features:
- Authenticate user using Google Sign in, with Firebase Authentication
- send/receive and store messages using Firebase Cloud Firestore 

# Integration guide
Please note that this project is currently running with my Firebase project, and I will not be able to add your Android SHA1 key. In order to run this project in your local, you need to integrate with your own Firebase project.

Steps by steps to integrate Firebase project into Flutter app:
- create Firebase project: https://console.firebase.google.com/
- Enable Firebase Authentication
- Enable Google sign in provider
- Enable Firebase Cloud Firestore
- in terminal, navigate to this project directory
- in terminal, run Flutter CLI to configure this project: 'flutterfire configure --project=your-project-name'
- follow on screen guide to complete Flutter CLI configuration

To run this project for Android platform
- open https://console.firebase.google.com/, go to your project, and check that apps are created
- in terminal, run this command to get Android debug keystore sha: keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
- copy Android debug SHA1, and to go https://console.firebase.google.com/project/your-project-name, open Project Setting, select Android app, and click on Add Fingerprint, and paste your SHA1 fingerprint here, then click Save
- Now your app is ready to run on Android

To run this project for iOS platform:
- open ios/Runner/Info.plist, search for line 'Copied from GoogleService-Info.plist key REVERSED_CLIENT_ID'
- open ios/Runner/GoogleService-Info.plist, search for string REVERSED_CLIENT_ID, and copy value of this REVERSED_CLIENT_ID key
- go back to ios/Runner/Info.plist, and paste this string into the string value above
- Now your app is ready to run on iOS

To run this project for Web platform:
- go to https://console.cloud.google.com/, and open your Firebase project
- go to APIs & Services, and select Credentials
- under OAuth 2.0 Client IDs, select your Web client, and copy Client ID under Additional information
- go back to your IDE, and open web/index.html
- search for key 'google-signin-client_id', and replace content value with Web Client ID copied above
- If there's error, check if your People API is enabled. Go to https://console.cloud.google.com/, select APIs & Services => Enabled APIs & Services, search for Google People API, and ensure it's enabled.
