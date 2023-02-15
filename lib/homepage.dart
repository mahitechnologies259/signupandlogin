import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

import 'services/crud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
    late String carModel;
    late String carColor;
    crudMethods crudObj = crudMethods();
    Stream<dynamic>? cars;

    @override
    void initState() {
      crudObj.getData().then((result){
        setState(() {
          cars = result;
        });
      });
      super.initState();
    }




  Future<void> addDialog(BuildContext context) async {
    return await showDialog (
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog (
            title: Text("Add Data", style: TextStyle(fontSize: 15),),
            content: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Enter Car Name",
                  ),
                  onChanged: (value){
                    carModel = value;
                  },
                ),
                SizedBox(height: 15,),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Enter Car Color",
                  ),
                  onChanged: (value){
                    carColor = value;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Map<String, String> carData = {
                    'CarName': carModel,
                    'CarColor': carColor
                  };
                  await crudObj.addData(carData);
                  // dialogTrigger(context);
                },
                child: Text(
                    "Add"
                ),
              )
            ],
          );
        }
    );
  }
  Future<void> updateDialog(BuildContext context, selectedDoc) async {
      return await showDialog (
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return AlertDialog (
              title: Text("Update Data", style: TextStyle(fontSize: 15),),
              content: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Car Name",
                    ),
                    onChanged: (value){
                      carModel = value;
                    },
                  ),
                  SizedBox(height: 15,),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Car Color",
                    ),
                    onChanged: (value){
                      carColor = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Map<String, String> carData = {
                      'CarName': carModel,
                      'CarColor': carColor
                    };
                    await crudObj.updateData(selectedDoc,carData);
                    // dialogTrigger(context);
                  },
                  child: Text(
                      "Update"
                  ),
                )
              ],
            );
          }
      );
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            addDialog(context);
          },
              icon: Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 5,
                child: _carList()),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text("You are now logged in"),
                  SizedBox(height: 15,),
                  OutlinedButton(
                      onPressed: (){
                        FirebaseAuth.instance.signOut()
                            .then((value){
                          Navigator.of(context).pushReplacementNamed('/landingpage');
                        }).catchError((e){
                          print(e);
                        });
                      },
                      child: Text("Logout")
                  ),
                ],
              ),
            ),


          ],
        )
      ),
    );
  }

  Future dialogTrigger(BuildContext context) {
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Job Done", style: TextStyle(fontSize: 15),),
            content: Text("Added"),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("Alright")
              )
            ],
          );
        }
    );
  }


  Widget _carList() {
    if(cars != null){
      return StreamBuilder(
        stream: cars,
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              padding: EdgeInsets.all(5),
              itemBuilder: (context, i){
                return ListTile(
                  title: Text(snapshot.data.docs[i].get("CarName")),
                  subtitle: Text(snapshot.data.docs[i].get("CarColor")),
                  onTap: (){
                    updateDialog(context, snapshot.data.docs[i].id.toString());
                  },
                  onLongPress: (){
                    crudObj.deleteData(snapshot.data.docs[i].id);
                  },
                );
              },
            );
          }
      );
    }
    else {
      return Text("loading ...");
    }
  }
}