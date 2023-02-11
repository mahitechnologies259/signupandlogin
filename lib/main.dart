
import 'package:flutter/material.dart';
import 'package:practice2/HomePage.dart';
import 'package:practice2/firebase_options.dart';
import 'package:practice2/loginpage.dart';
import 'package:practice2/signuppage.dart';
import 'package:firebase_core/firebase_core.dart';


main() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginPage(),
      routes: <String, WidgetBuilder>{
        '/landingpage': (BuildContext context) => new MyApp(),
        '/signup': (BuildContext context) => SignupPage(),
        '/homepage': (BuildContext context) => HomePage(),
      },
    );
  }
}

