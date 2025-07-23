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

class Photos extends StatefulWidget
{
  const Photos({super.key});

  @override
  State<Photos> createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {

  //PickedFile? pickedFile;
  XFile? pickedFile;
  String _error = "";
  String? _username = "";
  Map<String, dynamic>? images;
  SharedPreferences? notCookies;
  DateTime identifier = DateTime.now();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((nc)
    {
      notCookies = nc;
      _username = notCookies!.getString('username');
      fetchImages();
    });
  }

  Future<void> fetchImages() async
  {
    if (_username == null || _username!.isEmpty) 
    {
      return;
    }
    final doc = await FirebaseFirestore.instance.collection('users').doc(_username).get();
    if (doc.exists) {
      setState(() {
        Map<String, dynamic>? imagedata = doc.data()?['image'] as Map<String, dynamic>?;
        if (imagedata == null) imagedata = {};
        //images = doc.data()?['image'] as Map<String, dynamic>?;
        images = imagedata;
      });
    }
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
                          TextButton(
                            onPressed: ()
                            {
                              deleteImage(url);
                            },
                            child: Text("Delete Photo")
                            )
                        ],
                      )
                    )
                  );
                  /*return ElevatedButton
                  (
                    onPressed: ()
                    {
                      
                    },
                    child: Image.network(
                      url,
                      width: 250,
                      errorBuilder: (context, error, stackTrace) 
                      {
                        return Icon(Icons.broken_image);
                      },
                      )
                  );*/
                }
                ),
            ),
            Text(
              key: ValueKey('phototitle'),
              "(Shift Scroll to Scroll Horizantal)"
              ),
            Text(
              key: ValueKey('errorphotos'),
              _error,
              style: TextStyle(color: Colors.red),),
            TextButton(
              key: ValueKey('uploadPhoto'),
              onPressed: ()
              {
                chooseImage();
              },
              child: Text("Upload Image")),
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
  Future<void> chooseImage() async
  {
    if (notCookies == null)
    {
      notCookies = await SharedPreferences.getInstance();
      _username = notCookies!.getString('username');
    }
    else
    {
      _username = notCookies!.getString('username');
    }
    //await Permission.photos.request();
    //var permissionStatus = await Permission.photos.status;

    final xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (true) //permissionStatus.isGranted) 
    {
      if (xfile != null)
      {
        // "xfile.path is not usable on Flutter Web." search says
        //if(xfile.path.endsWith(".png") || xfile.path.endsWith(".jpg") || xfile.path.endsWith(".png") || xfile.path.endsWith(".gif"))
        if(true)
        {
          pickedFile = xfile;
          //var file = File(xfile.path);
          //var snapshot = await _firebaseStorage.ref()

          String id = identifier.toString();

          Uint8List bytes = await xfile.readAsBytes();
          String filePath = 'user_images/$_username/$id.png';

          final storage = FirebaseStorage.instanceFor(bucket: 'swe6733wc.firebasestorage.app');
          final ref = storage.ref().child(filePath);
          await ref.putData(bytes);
          String downloadURL = await ref.getDownloadURL();

          await FirebaseFirestore.instance.collection('users').doc(_username).set(
            {
              'image':
              {
                id: downloadURL
              } 
            },
            SetOptions(merge: true)
          );
          identifier = DateTime.now();
          fetchImages();
          return; 
        }
        //pickedFile = PickedFile(xfile.path);
      }
      setState(()
      {
        _error = "Image Upload Error";
      });
    }
    else
    {
      setState(()
      {
        _error = "Access Denied";
      });
    }
  }
  Future<void> deleteImage(String url) async
  {
    if (notCookies == null)
    {
      notCookies = await SharedPreferences.getInstance();
      _username = notCookies!.getString('username');
    }
    else
    {
      _username = notCookies!.getString('username');
    }
    String? id;
    images!.forEach((key, value) {
    print(key);
    if (value == url) 
    {
      id = key;
      print("Match: $key");
    }
  });
    try
    {
      /*await FirebaseFirestore.instance.collection('users').doc(_username).update(
      {
        'image.$id': FieldValue.delete()
      });*/
      Map<String, dynamic> updatedImages = Map<String, dynamic>.from(images!);
      updatedImages.remove(id);
      await FirebaseFirestore.instance.collection('users').doc(_username).update(
      {
        'image': updatedImages,
      });

    }catch(e)
    {
      setState(() {
      _error = "Failed to delete image properly firestore:";
    });}
    try
    {
      final storage = FirebaseStorage.instanceFor(bucket: 'swe6733wc.firebasestorage.app');
      final ref = storage.ref().child('user_images/$_username/$id.png');
      await ref.delete();
    }catch(e)
    {
      setState(() {
      _error = "Failed to delete image properly firebasestorage:";
    });}
    fetchImages();
  }
}