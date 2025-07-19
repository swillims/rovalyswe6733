import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// I don't know why have this one and afraid to remove it
import 'package:flutter/services.dart';

// next scene after login
import 'home.dart';


class Chat extends StatefulWidget
{
  @override
  State<Chat> createState() => _ChatState();
}

// This scene is pretty messy. Don't review it.

class _ChatState extends State<Chat> 
{
  String input = "";
  String _error = "";
  String? _username = "";
  String currentChat = "";
  List<dynamic>? chats;
  List<dynamic>? messages;
  //List<String>;
  //List<String>? lastMessages;
  List<List<String>>? lastMessages; // consider rename var because it is last message + foreign key to chat
  SharedPreferences? notCookies;
  DateTime identifier = DateTime.now();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((nc)
    {
      notCookies = nc;
      _username = notCookies!.getString('username');
      //fetchImages();
      fetchChats();
    });
  }
  @override
  Widget build(BuildContext context) 
  {
    if (chats == null) 
    {
      return Scaffold
      (
        appBar: AppBar(title: Text('Rovaly')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (chats!.isEmpty)
    {
      return Scaffold
      (
        appBar: AppBar(title: Text('Rovaly')),
        body: Center
        (
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [
              Text("No Chats")
            ],
          )
          //Text("No Chats")
        ),

      );
    }
    if(currentChat=="")
    {
      return Scaffold
        (
          appBar: AppBar(title: Text('Rovaly')),
          body: Center
          (
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                Text("Chats"),
                SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder
                (
                  itemCount: chats!.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index)
                  {
                    return SizedBox
                    (
                      height: 50,
                      child: Align
                      (
                        alignment: Alignment.topCenter,
                        child: Row
                        (
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                          [
                            TextButton
                            (
                              onPressed: ()
                              {

                              },
                              child: Text("Remove Chat")
                            ),
                            TextButton
                            (
                              onPressed: ()
                              {
                                fetchMessages(lastMessages![index][0]);
                                //etState(() 
                                //{
                                //  fetchMessages(lastMessages![index][0]);
                                //  currentChat = lastMessages![index][0];
                                //});
                              },
                              child: Text(lastMessages![index][1])
                            )
                          ],
                        )
                      )
                    );
                  }
                ),
              ),
            ],
          )
          //Text("No Chats")
        ),
      );
    }

    // chat subscene
    return Scaffold
        (
          appBar: AppBar(title: Text('Rovaly')),
          body: Center
          (
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                Text("Chats"),
                SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder
                (
                  itemCount: messages!.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index)
                  {
                    String user = messages![index].value['user'];
                    String message = messages![index].value['text'];
                    return SizedBox
                    (
                      height: 50,
                      child: Align
                      (
                        alignment: Alignment.topCenter,
                        child: Row
                        (
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                          [
                            Text(user),
                            Text(": "),
                            Text(message),
                          ],
                        )
                      )
                    );
                  }
                ),
              ),
              SizedBox
              ( 
                height: 50,
                child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    [
                      TextButton
                      (
                        onPressed: ()
                        {
                          chatSend(input);
                        },
                        child: Text("Send")
                      ),
                      Expanded
                      (
                        child: TextField( onChanged: (value)  
                        {
                          input = value;
                        },)
                      ),
                    ],
                  ),
              )
              ],
            )
          //Text("No Chats")
        ),
      );
  }
  void fetchChats() async 
  {
    if (_username == null || _username!.isEmpty) 
    {
      return;
    }
    final doc = await FirebaseFirestore.instance.collection('users').doc(_username).get();
    if (doc.exists) {
      
      List<dynamic>? chatdata = doc.data()?['chats'] as List<dynamic>?;
      if (chatdata == null) chatdata = [];
      //images = doc.data()?['image'] as Map<String, dynamic>?;

      chats = chatdata;
      lastMessages = [];
      for(String c in chatdata)
      {
        final doc = await FirebaseFirestore.instance.collection('chats').doc(c).get();
        //print(docdata);
        final doclist = doc.data()!["message"]!.entries.toList();
        doclist.sort((a, b)
        {
          final aTime = a.value['time'] ?? 0;
          final bTime = b.value['time'] ?? 0;
          return (aTime as int).compareTo(bTime as int);
        });
        //final data = doclist.first.value;
        final data = doclist.last.value;
        String display = data['user'] + ": " + data['text'];
        lastMessages!.add([c, display]);
      } 
      setState(() 
      {
        ""; // Don't delete this. It does nothing on purpose. Set state needs to do something to queue a rebuild.
      });
    }
  }
  void fetchMessages(String chatprimkey) async
  {
    final doc = await FirebaseFirestore.instance.collection('chats').doc(chatprimkey).get();
    final doclist = doc.data()!["message"]!.entries.toList();
    doclist.sort((a, b) 
    {
      final aTime = a.value['time'] ?? 0;
      final bTime = b.value['time'] ?? 0;
      return (aTime as int).compareTo(bTime as int);
    });
    messages = doclist;
    setState(() 
      {
        currentChat = chatprimkey;
      });
  }
  void chatSend(String message) async
  {
    DateTime time = DateTime.now();
    await FirebaseFirestore.instance.collection('chats').doc(currentChat).set(
    {
      'message':
      {
        Timestamp.fromDate(time).millisecondsSinceEpoch.toString() + " null user":
        {
          'user': _username,
          'time': time.millisecondsSinceEpoch,
          'text': message,
          }
        }
      },
      SetOptions(merge: true));

    fetchMessages(currentChat);
  }
}