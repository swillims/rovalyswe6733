// may use later idk
import 'main.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Rovaly"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              key: ValueKey('hometitle'),
              "Home" // update test case if this is changed
              ),
            TextButton(
              key: ValueKey('matches'),
              onPressed: ()
              {

              },
              child: Text("Match with people")),
            TextButton(
              key: ValueKey('photos'),
              onPressed: ()
              {

              },
              child: Text("filler text")),
            TextButton(
              key: ValueKey('settings'),
              onPressed: ()
              {

              },
              child: Text("filler text")),
            TextButton(
              key: ValueKey('logout'),
              onPressed: ()
              {

              },
              child: Text("filler text")),
          ],
        )
      )
    );
  }
  
}