import 'dart:convert';
import 'dart:typed_data';

import 'package:rovalyswe6733/home.dart';

//import 'main.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Matches extends StatefulWidget
{
  @override
  State<Matches> createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {

  String _error = "";
  String? _username = "";
  String _currentmatch = "";
  String _scrollText = "Loading"; // this looks weird because it is
  List<String> _usernames = []; // consider refactoring to _potentialmatches
  Map<String, dynamic>? images;
  SharedPreferences? notCookies;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((nc)
    {
      notCookies = nc;
      _username = notCookies!.getString('username');
      
      /*fetchImages("aaab").then((_)
      {
        getNewMatches();
      });*/
      getNewMatches();
    });
     // move/delete me later
  }

  @override
  Widget build(BuildContext context)
  {
    if (images == null) 
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
      //body: Center(
        //child: Column(
      body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.builder
              (
                itemCount: images!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index)
                {
                  String url = images!.values.elementAt(index);
                  return SizedBox
                  (
                    height: 300,
                    child: Align
                    (
                      alignment: Alignment.bottomCenter,
                      child: Column
                      (
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children:
                        [
                          Image.network
                          (
                            url,
                            height: 300,
                            errorBuilder: (context, error, stackTrace) 
                            {
                              return Icon(Icons.broken_image);
                            },
                          ),
                        ],
                      )
                    )
                  );
                }
                ),
            ),
            Text(
              key: ValueKey('scrollText'),
              _scrollText
              //"(Shift Scroll to Scroll Horizantal)"
              ),
            
            Text(
              key: ValueKey('matchText'),
              "Username: " + _currentmatch,
            ),
            Text(
              key: ValueKey('errorMatches'), // I don't think this is used but I'm not deleting it because the extra space looks good and it's an option for later
              _error,
              style: TextStyle(color: Colors.red),),
            Row
            (
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
              [
                TextButton(
                key: ValueKey('approveMatch'),
                onPressed: ()
                {
                  setMatch(_currentmatch, true);
                },
                child: Text("Approve Match")),
                TextButton(
                key: ValueKey('declineMatch'),
                onPressed: ()
                {
                  setMatch(_currentmatch, false);
                },
                child: Text("Decline Match")),
              ],
            ),
            
            TextButton(
              key: ValueKey('photogohome'),
              onPressed: ()
              {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Home(),
                  )
              );
              },
              child: Text("Home Screen")),
          ],
        )
//      )
    );
  }
  
  Future<void> getNewMatches() async
  {
    if (_username == null || _username!.isEmpty) 
    {
      return;
    }
    CollectionReference<Map<String, dynamic>> users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot<Map<String, dynamic>> snapshot = await users.get();
    
    //List<String> usernames = snapshot.docs.map((doc) => doc.data()['users'] as String?).whereType<String>().toList();
    final userdata = await FirebaseFirestore.instance.collection('users').doc(_username).get();

    List<String> usernames = snapshot.docs.map((doc) => doc.id).toList();
    
    if(usernames.contains(_username)) usernames.remove(_username); // remove self
    
    // remove past matches
    //Map<String, dynamic> statuses = Map<String, dynamic>.from(userdata['matchstatus']);
    //if(statuses == null) statuses = {};
    //for(String pastMatch in Map<String, dynamic>.from(userdata['matchstatus']).keys.toList())
    final Map<String, dynamic> data = userdata.data() ?? {};
    final Map<String, dynamic> matchstatus = Map<String, dynamic>.from(data['matchstatus'] ?? {});
    //for(String pastMatch in statuses.keys.toList())
    for (String pastMatch in matchstatus.keys)
    {
      if(usernames.contains(pastMatch)) usernames.remove(pastMatch);
    }

    for(int i = usernames.length -1; i >= 0; i--)
    {
      print("checking" + usernames[i]);
      if(!await checkUser(usernames[i]))
      {
        usernames.removeAt(i);
      }
    }
    // I think it's better to assine the list this way because checkUser is async.
    // We don't want to update the list to the new one until it is done processing

    _usernames = usernames; 
    print("Usernames: $_usernames");
    await getNextMatch(); // await optional because end of method
  }
  
  Future<bool> checkUser(uu) async
  {
    // sprint3 do code to check for distance, adventure type, etc..
    return true;
  }

  Future<void> getNextMatch() async
  {
    if(_usernames.length==0)
    {
      setState
      (() {
        _currentmatch = "";
        _scrollText = "No matches found :(" ; // 
        images = {};
      });
      return;
    }
    // setState() is in fetchImages
    _currentmatch = _usernames[0];
    _scrollText = "(Shift Scroll to Scroll Horizantal)";
    //"Username: " + _usernames[0]; // use this somewhere if refactoring for prettier
    await fetchImages(_usernames[0]);
  }

  Future<void> fetchImages(String username) async
  {
    print("fetch images" + username);
    if (username == null || username!.isEmpty) 
    {
      setState
      ((){
        images = {};
      });
      return;
    }
    final doc = await FirebaseFirestore.instance.collection('users').doc(username).get();
    if (doc.exists) {
      Map<String, dynamic>? imagequarry = doc.data()?['image'] as Map<String, dynamic>?;
      if(imagequarry==null)
      {
        imagequarry = {};
        _scrollText = "No images found";
      }
      setState(() {
        //images = doc.data()?['image'] as Map<String, dynamic>?;
        images = imagequarry;
      });
    }
  }
  Future<void> setMatch(String target, bool matchStatus) async
  {
    if(target==null || target=="") return;

    final fb = FirebaseFirestore.instance.collection('users');
    //await FirebaseFirestore.instance.collection('users').doc(_username).set
    await fb.doc(_username).set
    ({
      'matchstatus':
      {
        target: matchStatus
      } 
    }, SetOptions(merge: true));
    if(_usernames.contains(target)) _usernames.remove(target);
    if(matchStatus) // true = to confirm match // need to logic to check if mutual match
    {
      final targetDoc = await fb.doc(target).get();
      final targetData = targetDoc.data();
      if(targetData != null) // null check // this one might not be necessary but afraid to get rid of it
      {
        //final targetMatches = Map<String, dynamic>.from(targetData['matchstatus']);
        final targetMatches = Map<String, dynamic>.from(targetData['matchstatus'] ?? {});
        //if(target != null) //null check
        if(true) // left in because didn't want to realign code after fixing a thing
        {
          if(targetMatches.containsKey(_username) && targetMatches[_username] == true) // short circuit operator handles null check
          {
            String primKey = _username! + "§" +  target; //ide made me randomly add a null check
            await fb.doc(_username).set(
              {
                'chats': FieldValue.arrayUnion([primKey])
              },SetOptions(merge: true));
            await fb.doc(target).set(
              {
                'chats': FieldValue.arrayUnion([primKey])
              },SetOptions(merge: true));
            DateTime time = DateTime.now();
            await FirebaseFirestore.instance.collection('chats').doc(primKey).set(
              {
                'message':
                {
                  Timestamp.fromDate(time).millisecondsSinceEpoch.toString() + " null user":
                  {
                    'user': "auto send",
                    //'time': Timestamp.fromDate(time),
                    'time': time.millisecondsSinceEpoch,
                    'text': "new chat opened",
                  }
                }
              },
              SetOptions(merge: true));
              //print("millisecondsSinceEpoch: ${time.millisecondsSinceEpoch}");
          }
        }
      }
    }
    await getNextMatch(); // await optional because end of method
  }
}