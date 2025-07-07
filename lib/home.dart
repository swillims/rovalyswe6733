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
          children: [
            Text(
              key: ValueKey('title'),
              "Home" // update test case if this is changed
              )
          ],
        )
      )
    );
  }
  
}