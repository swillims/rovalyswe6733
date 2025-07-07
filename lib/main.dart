import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// I don't know why have this one and afraid to remove it
import 'package:flutter/services.dart';

// next scene after login
import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAe5kTlgtp7KP7MuIQ6L8wqKj0jclPB9yM",
      authDomain: "swe6733wc.firebaseapp.com",
      projectId: "swe6733wc",
      storageBucket: "swe6733wc.appspot.com",
      messagingSenderId: "292059682722",
      appId: "1:292059682722:web:b67ec047322f30955784fb",
      measurementId: "G-14V6B2ZW08",
    ),
  ).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rovaly',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Rovaly'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;
  String _username = "";
  String _password = "";
  String _error = "";

  /*void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });

    // This was just to test database connection
    //FirebaseFirestore.instance.collection('counters').add(
    //  {
    //  'count': _counter,
    //  'timestamp': FieldValue.serverTimestamp(),
    //  });
  }*/
  void _login()
  {
    if(_username.isEmpty)
    {
      setState(() 
      {
        _error = "Missing Username";
      });
      return;
    }
    if(_password.isEmpty)
    {
      setState(() 
      {
        _error = "Missing Password";
      });
      return;
    }
    FirebaseFirestore.instance.collection('users').doc(_username).get().then((dataSearch) 
    {
      if(!dataSearch.exists)
      {
        setState(()
        {
          _error = "Username/Password is incorrect";
        });
        return;
      }
      //Map<String, dynamic>? data = dataSearch.data();
      final data = dataSearch.data();
      if(data != null && data.containsKey('password'))
      {
        if(_password == data['password'])
        {
          SharedPreferences.getInstance().then((notCookies)
          {
            notCookies.setBool('loggedIn', true); // I don't know if this is needed
            notCookies.setString('username', _username);
            Navigator.push(context,
              MaterialPageRoute
              (
                builder: (_) => Home(),
              ));
          });
          
        }
        else
        {
          setState(()
          {
            _error = "Username/Password is incorrect";
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //const Text('You have pushed the button this many times:'),
            //Text(
            //  '$_counter',
            //  style: Theme.of(context).textTheme.headlineMedium,
            //),
            Text("Login"),
            Text(
              key: ValueKey('errormessage'),
              _error,
              style: TextStyle(color: Colors.red),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("UserName:"),
                SizedBox(
                  width: 200.0,
                  child: TextFormField
                  (
                    key: ValueKey('usename'),
                    onChanged: (input) {_username = input;},
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Password:"),
                SizedBox(
                  width: 200.0,
                  //child: TextField(textAlign: TextAlign.left,),
                  child: TextFormField
                  (
                    key: ValueKey('password'),
                    onChanged: (input) {_password = input;},
                  ),
                )
              ],
            ),
            //TextField(textAlign: TextAlign.center,),
            //TextField(textAlign: TextAlign.center,),
            TextButton(
              key: ValueKey('loginbutton'),
              onPressed: _login, child: Text("Login")
              ), //login has a lot of logic so not doing functional coding here
            TextButton(
              key: ValueKey('createaccount'),
              onPressed: () 
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateAccount(),
                  )
              );
              }, child: Text("Create Account")),
          ],

        ),
      ),
      //floatingActionButton: FloatingActionButton(
      //  onPressed: _incrementCounter,
      //  tooltip: 'Increment',
      //  child: const Icon(Icons.add),
      //), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CreateAccount extends StatefulWidget
{
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String _username = "";
  String _password = "";
  String _error = "";
   @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Rovaly"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Create Account"),
            Text(
              key: ValueKey('errormessage2'),
              _error,
              style: TextStyle(color: Colors.red),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("UserName:"),
                SizedBox(
                  width: 200.0,
                  child: TextFormField
                  (
                    key: ValueKey('usename2'),
                    onChanged: (input) {_username = input;},
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Password:"),
                SizedBox(
                  width: 200.0,
                  //child: TextField(textAlign: TextAlign.left,),
                  child: TextFormField
                  (
                    key: ValueKey('password2'),
                    onChanged: (input) {_password = input;},
                  ),
                )
              ],
            ),
            TextButton(
              key: ValueKey('createaccount2'),
              onPressed: () {
                //then used to avoid async
                //setState(() {
                //    _error = "checking..."; // I don't know why this makes the next one display but skips this one but it fixes the next one
                //  });
                if(_username.isEmpty)
                {
                  setState(() {
                    _error = "Missing Username";
                    });
                    return;
                }
                if(_password.isEmpty)
                {
                  setState(() {
                    _error = "Missing Password";
                    });
                    return;
                }
                FirebaseFirestore.instance.collection('users').doc(_username).get().then((dataSearch) 
                {
                  if(dataSearch.exists)
                  {
                    setState(() {
                    _error = "Username already exists";
                    });
                    return;
                  }
                  FirebaseFirestore.instance.collection('users').doc(_username).set({
                    'password': _password, // Don't store plain passwords in production
                    }).then((_) 
                    {
                      Navigator.push(context,
                      MaterialPageRoute(
                        builder: (_) => MyApp(),
                        )
                      );
                    });
                }
                );
              },
              child: Text("Create Account")
             )
          ]
        ),
      ),
      ),
    );
  }
}