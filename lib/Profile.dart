import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget{
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
  String? _username;
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
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Rovaly"),
      ),
      body: Center(child:  Row(
        children: [
          //Display User Icon,
          Text(_username?? "DefaultUser"),
          TextButton(onPressed: () {throw Exception("Not Implemented");}, child: Text("Edit"))
        ],
      ))
    );
  }
}