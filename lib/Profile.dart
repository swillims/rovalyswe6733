import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'home.dart';

import 'main.dart';

class Profile extends StatefulWidget{
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}


class _ProfileState extends State<Profile>{
  String? _username;

  Map<String, bool>? hasAdventureTypes;
  List<String>? adventureTypes = ['hiking', 'canoeing', 'rock climbing', 'cave diving'];

  
  String _error = "";
  SharedPreferences? notCookies;
  dynamic _userIcon;

  @override
  void initState(){
    super.initState();
    SharedPreferences.getInstance().then((nc)
    {
      notCookies = nc;
      _username = notCookies!.getString('username');
      fetchAdventureTypes().then((_){
        setState(() {
          "";
        });
      });
      setState(() {
        //DO NOT DELETE. Required to run Setstate
        "";
      });
    });
  }

  Future fetchAdventureTypes() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(_username).get();

    if (doc.exists){
      final raw = doc.data()?['adventureTypes'];
      if (raw is Map<String, dynamic>) {
        hasAdventureTypes = raw.map((key, value) => MapEntry(key, value as bool));
      }
    }

    if (hasAdventureTypes == null){
      hasAdventureTypes = {};
    }
      
    for(var key in adventureTypes!)
      if(!hasAdventureTypes!.containsKey(key)){
        hasAdventureTypes![key] = false;
      }
  }
  Future saveAdventureTypes() async {
    print("Saving Adventure Types...");
    await FirebaseFirestore.instance.collection('users').doc(_username).set(
    {
      'adventureTypes': hasAdventureTypes
    },
      SetOptions(merge: true));
    
    print("saved Adventure Types");
  
  }
  
  @override
  Widget build(BuildContext context) {
    if (hasAdventureTypes == null) 
    {
      return Scaffold
      (
        appBar: AppBar(title: Text('Rovaly')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Rovaly"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Display User Icon,
          Text((_username?? "DefaultUser") + "| Adventure Type Preferences"),
          Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(adventureTypes![0] + ": "),
              TextButton(onPressed: () 
              {
                if (adventureTypes != null && hasAdventureTypes != null && adventureTypes!.isNotEmpty) {
                  final key = adventureTypes![0];
                   hasAdventureTypes![key] = !(hasAdventureTypes![key] ?? false);
                }
                setState(() {
                  "";
                });
              }, 
              child: Text(hasAdventureTypes![adventureTypes![0]].toString()))
            ],
          
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(adventureTypes![1] + ": "),
              TextButton(onPressed: () 
              {
                if (adventureTypes != null && hasAdventureTypes != null && adventureTypes!.isNotEmpty) {
                  final key = adventureTypes![1];
                   hasAdventureTypes![key] = !(hasAdventureTypes![key] ?? false);
                }
                setState(() {
                  "";
                });
              }, 
              child: Text(hasAdventureTypes![adventureTypes![1]].toString()))
            ],
          
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(adventureTypes![2] + ": "),
              TextButton(onPressed: () 
              {
                if (adventureTypes != null && hasAdventureTypes != null && adventureTypes!.isNotEmpty) {
                  final key = adventureTypes![2];
                   hasAdventureTypes![key] = !(hasAdventureTypes![key] ?? false);
                }
                setState(() {
                  "";
                });
              }, 
              child: Text(hasAdventureTypes![adventureTypes![2]].toString()))
            ],
          
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(adventureTypes![3] + ": "),
              TextButton(onPressed: () 
              {
                if (adventureTypes != null && hasAdventureTypes != null && adventureTypes!.isNotEmpty) {
                  final key = adventureTypes![3];
                   hasAdventureTypes![key] = !(hasAdventureTypes![key] ?? false);
                }
                setState(() {
                  "";
                });
              }, 
              child: Text(hasAdventureTypes![adventureTypes![3]].toString()))
            ],
          
          ),
          TextButton(onPressed: () {saveAdventureTypes().then((_) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Home(),
                  ));
          });}, child: Text("Apply Changes")),
          TextButton(onPressed: () {saveAdventureTypes().then((_) {
            delete();
          });}, child: Text("Delete Account")),
        ],
      )
    );
  }

  void delete() async
  {
    await FirebaseFirestore.instance.collection('users').doc(_username).delete();

    notCookies!.setBool('loggedIn', false);
    notCookies!.setString('username', _username!);
    Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyApp(),
                  ));
  }
}