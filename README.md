# devfest_chat

A simple Chat app to demonstrate Firebase in Flutter

## Environment

- Flutter 3.24.3
- Xcode 15.4
- Pod 1.13.0
- Dart 3.5.3

## Integrate Firebase into Flutter project

Step 1: Install Firebase CLI
Official document is at <a href="https://firebase.google.com/docs/cli">Firebase CLI</a>

Step 2: Login to Firebase CLI, run this commandline

```bash
    firebase login
```

Step 3: activate FlutterFire CLI (included in Firebase CLI)

```bash
    dart pub global activate flutterfire_cli
```

Step 4: Run flutterfire configure command

```bash
    flutterfire configure --project=<your project name>
```

Step 5: Add firebase_core

```bash
    flutter pub add firebase_core
```

Detail of these steps can be found <a href="https://firebase.google.com/docs/flutter/setup">here</a>

## Support
<a href="https://www.buymeacoffee.com/suesitran"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=suesitran&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff" /></a>
