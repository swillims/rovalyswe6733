// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:rovalyswe6733/main.dart';
import 'dart:math';

void main() {

  String noneString = "";
  String userNameCorrect = randString(20);
  String userNameWrong = randString(21); 
  String passwordCorrect = randString(20);
  String passwordWrong = randString(21); 

  //TestWidgetsFlutterBinding.ensureInitialized();
  
  /*
    await Firebase.initializeApp
    (
      options: const FirebaseOptions(
      apiKey: "AIzaSyAe5kTlgtp7KP7MuIQ6L8wqKj0jclPB9yM",
      authDomain: "swe6733wc.firebaseapp.com",
      projectId: "swe6733wc",
      storageBucket: "swe6733wc.appspot.com",
      messagingSenderId: "292059682722",
      appId: "1:292059682722:web:b67ec047322f30955784fb",
      measurementId: "G-14V6B2ZW08",
    ));
  });*/


  /*testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });*/
  testWidgets('Account Creation and login fail / succeed', (WidgetTester tester) async
  {

    /*


    I did some research and this probably won't work
    initializeApp runs local with no browswer type bs idk
    "flutter test runs in a pure Dart VM" no plugins for firebase
    can transition to 2nd scene but not access database so fail on user story 1 and all user stories past it.    

    ^^^ Read this before trying to to write test cases here ^^^

    flutter drive --driver integration_test/driver.dart --target integration_test/web_test.dart -d chrome
    instead do this.

    /*tester.printToConsole('Intialize App');
    await Firebase.initializeApp(
      options: const FirebaseOptions(
      apiKey: "AIzaSyAe5kTlgtp7KP7MuIQ6L8wqKj0jclPB9yM",
      authDomain: "swe6733wc.firebaseapp.com",
      projectId: "swe6733wc",
      storageBucket: "swe6733wc.appspot.com",
      messagingSenderId: "292059682722",
      appId: "1:292059682722:web:b67ec047322f30955784fb",
      measurementId: "G-14V6B2ZW08",
    ),
    );*/
    TestWidgetsFlutterBinding.ensureInitialized();
    tester.printToConsole('Test Start');
    Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAe5kTlgtp7KP7MuIQ6L8wqKj0jclPB9yM",
      authDomain: "swe6733wc.firebaseapp.com",
      projectId: "swe6733wc",
      storageBucket: "swe6733wc.appspot.com",
      messagingSenderId: "292059682722",
      appId: "1:292059682722:web:b67ec047322f30955784fb",
      measurementId: "G-14V6B2ZW08",
    ),).then((_) 
    {
      tester.printToConsole('Then');
    });
    //await Firebase.initializeApp();
    tester.printToConsole('Initialized Firebase');
    //await tester.pumpWidget(const MyApp());

    // Chapter 1: Create Account
    // Navigate to Create Account screen
    tester.printToConsole('Change Scene to account creation');
    await tester.tap(find.byKey(ValueKey('createaccount')));
    await tester.pumpAndSettle();
    await tester.pump();
    // create account no user/name password
    tester.printToConsole('Try no username error');
    await tester.tap(find.byKey(ValueKey('createaccount2')));
    await tester.pumpAndSettle();
    await tester.pump();
    final errorText = tester.widget<Text>(find.byKey(ValueKey('errormessage2')));
    expect(errorText.data, equals("Missing Username"));
    // input a username
    tester.printToConsole('Try no password error');
    await tester.enterText(find.byKey(ValueKey('usename2')), userNameCorrect);
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('createaccount2')));
    await tester.pumpAndSettle();
    await tester.pump();
    final errorText2 = tester.widget<Text>(find.byKey(ValueKey('errormessage2')));
    expect(errorText2.data, equals("Missing Password"));
    // actually create the account
    tester.printToConsole('Create Account');
    await tester.enterText(find.byKey(ValueKey('usename2')), userNameCorrect);
    await tester.enterText(find.byKey(ValueKey('password2')), passwordCorrect);
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('createaccount2')));
    await tester.pumpAndSettle();
    await tester.pump();
    // check if return to home page
    expect(find.byKey(ValueKey('createaccount2')), findsNothing);

    // Chapter 2: Login
    //final errorText2 = tester.widget<Text>(find.byKey(ValueKey('errormessage2')));
    */
  });
  
}

String randString(int size)
{
  String str = "";
  for (int i = 0; i<size; i++) {
    str += String.fromCharCode(Random().nextInt(126-32)+32);
  }

  return str;
}