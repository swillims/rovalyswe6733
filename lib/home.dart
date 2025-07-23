// may use later idk
import 'package:rovalyswe6733/Profile.dart';

import 'main.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//
//
import 'matches.dart';
//
import 'chat.dart';
//
import 'photos.dart';

class Home extends StatelessWidget
{
  const Home({super.key});

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
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Matches(),
                  )
              );
              },
              child: Text("Match with people")),
            TextButton(
              key: ValueKey('photos'),
              onPressed: ()
              {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Photos(),
                  )
              );
              },
              child: Text("Upload/Manage Photos")),
            TextButton(
              key: ValueKey('chat'),
              onPressed: ()
              {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Chat(),
                  )
              );
              },
              child: Text("View Chats")),
            TextButton(
              key: ValueKey('settings'),
              onPressed: ()
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Profile(),
                    )
                );
              },
              child: Text("Profile & Settings")),
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