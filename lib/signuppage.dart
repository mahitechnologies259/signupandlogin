import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice2/services/usermanagement.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

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
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: (){
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(email: _email, password: _password)
                      .then((signedInUser){
                        UserManagement().storeNewUser(signedInUser, context);
                  }).catchError((e){
                    print(e);
                  });
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
