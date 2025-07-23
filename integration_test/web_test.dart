import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:math';
import 'package:rovalyswe6733/main.dart';

void main() {
  String noneString = "";
  String userNameCorrect = randString(20);
  String userNameWrong = randString(21); 
  String passwordCorrect = randString(20);
  String passwordWrong = randString(21); 
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // flutter drive --driver integration_test/driver.dart --target integration_test/web_test.dart -d chrome
  // to run

  // known issue with printToConsole not working with drive. Not using it is fine.

  // expect also appears to not be crashing correctly?

  testWidgets('Account Creation and Login Test', (WidgetTester tester) async {
    tester.printToConsole('Test Start');

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
    );
    tester.printToConsole('Firebase Initialized!');

    //await tester.pumpWidget(const MyApp());
    //await tester.pumpAndSettle();

    try
    {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      tester.printToConsole('init successful');
    } catch (e, stack)
    {
      tester.printToConsole('it not work: $e');
      tester.printToConsole(stack.toString());
    }
    await sleep(tester,10);
    await tester.pump();

    // Chapter 1: Create Account
    // Move to Create Account Scene
    await tester.tap(find.byKey(ValueKey('createaccount')));
    await tester.pumpAndSettle();
    await sleep(tester,5);
    await tester.pump();
    // create account no user/name password
    await tester.tap(find.byKey(ValueKey('createaccount2')));
    await tester.pumpAndSettle();
    await sleep(tester,2);
    await tester.pump();
    final errorText = tester.widget<Text>(find.byKey(ValueKey('errormessage2')));
    expect(errorText.data, equals("Missing Username"));
    // input a username
    tester.printToConsole('Try to validate: no password error');
    await tester.enterText(find.byKey(ValueKey('usename2')), userNameCorrect);
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('createaccount2')));
    await tester.pumpAndSettle();
    await sleep(tester,2);
    await tester.pump();
    final errorText2 = tester.widget<Text>(find.byKey(ValueKey('errormessage2')));
    expect(errorText2.data, equals("Missing Password"));
    // actually create the account
    await tester.enterText(find.byKey(ValueKey('usename2')), userNameCorrect);
    await tester.enterText(find.byKey(ValueKey('password2')), passwordCorrect);
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('createaccount2')));
    await tester.pumpAndSettle();
    await sleep(tester,5);
    await tester.pump();
    expect(find.byKey(ValueKey('createaccount2')), findsNothing);

    // Chapter 2: Login
    // no username
    await tester.tap(find.byKey(ValueKey('loginbutton')));
    await tester.pumpAndSettle();
    await tester.pump();
    final errorText3 = tester.widget<Text>(find.byKey(ValueKey('errormessage')));
    expect(errorText3.data, equals("Missing Username"));
    // no username
    await tester.enterText(find.byKey(ValueKey('usename')), userNameWrong);
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('loginbutton')));
    await tester.pumpAndSettle();
    await sleep(tester,1);
    await tester.pump();
    final errorText4 = tester.widget<Text>(find.byKey(ValueKey('errormessage')));
    expect(errorText4.data, equals("Missing Password"));

    //wrong username
    await tester.enterText(find.byKey(ValueKey('usename')), userNameWrong);
    await tester.enterText(find.byKey(ValueKey('password')), passwordCorrect);
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('loginbutton')));
    await tester.pumpAndSettle();
    await tester.pump();
    await sleep(tester,1);
    final errorText5 = tester.widget<Text>(find.byKey(ValueKey('errormessage')));
    expect(errorText5.data, equals("Missing Password"));

    //login correct
    await tester.enterText(find.byKey(ValueKey('usename')), userNameCorrect);
    await tester.enterText(find.byKey(ValueKey('password')), passwordCorrect);
    await sleep(tester,1);
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('loginbutton')));
    await tester.pumpAndSettle();
    await sleep(tester,2);
    await tester.pump();
    await sleep(tester,1);
    final errorText6 = tester.widget<Text>(find.byKey(ValueKey('hometitle')));
    expect(errorText6.data, equals("Home"));
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

Future<void> sleep(WidgetTester t, seconds) async
{
  for (int i = 0; i < seconds*2; i++) {
    await t.pump(const Duration(milliseconds: 500));
  }
}