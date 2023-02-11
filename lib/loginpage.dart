import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late String _email; //Private Variable
  late String _password; //Private Variable


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                ),
                onChanged: (value){
                  setState(() {
                    _email= value;
                  });
                },
              ),
              SizedBox(height: 15,),
              TextField(
                decoration: InputDecoration(
                  labelText: "Password",
                ),
                onChanged: (value){
                  setState(() {
                    _password= value;
                  });
                },
              ),
              SizedBox(height: 15,),
              ElevatedButton(
                onPressed: (){
                  FirebaseAuth.instance.
                  signInWithEmailAndPassword(email: _email, password: _password)
                      .then((user){
                    Navigator.of(context).pushReplacementNamed('/homepage');
                  })
                      .catchError((e) => print(e));
                },
                child: Text(
                  "Login", style: TextStyle(fontSize: 22),
                ),
              ),
              SizedBox(height: 15,),
              ElevatedButton(
                onPressed: (){
                  // GoogleSignInAccount googleSignInAccount = GoogleSignIn().signIn() as GoogleSignInAccount;
                  // GoogleSignInAuthentication googleSignInAuthentication = googleSignInAccount.authentication as GoogleSignInAuthentication;
                  // FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider
                  //     .credential(idToken: googleSignInAuthentication.idToken,
                  //     accessToken: googleSignInAuthentication.accessToken)).then((signedInUser){
                  //       print("Signed in as $signedInUser");
                  // })
                  // .catchError((e){
                  //   print(e);
                  // });

                  GoogleSignIn().signIn().then((result){
                    result?.authentication.then((googleKey){
                      FirebaseAuth.instance.signInWithCredential(
                        GoogleAuthProvider.credential(idToken: googleKey.idToken, accessToken: googleKey.accessToken)
                      ).then((signedInUser) {
                        print("Signed In as $signedInUser");
                      }).catchError((e)=> print(e));
                    }).catchError((e)=> print(e));
                  }).catchError((e)=> print(e));
                },
                child: Text(
                  "Sign in with Google", style: TextStyle(fontSize: 22),
                ),
              ),
              SizedBox(height: 15,),
              Text("Don't have an account?"),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushNamed('/signup');
                },
                child: Text(
                  "SignUp", style: TextStyle(fontSize: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
