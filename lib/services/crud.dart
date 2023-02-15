import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class crudMethods{
  Future<bool> isLoggedIn() async {
    if (await FirebaseAuth.instance.currentUser != null ){
      return true;
    }
    else{
      return false;
    }
  }

  Future<void> addData(carData) async{
    if(await isLoggedIn()){
      // FirebaseFirestore.instance.collection('textcrud').add(carData)
      //     .catchError((e){
      //       print(e);
      // });
      
      FirebaseFirestore.instance.runTransaction((transaction) async {
        CollectionReference reference = await FirebaseFirestore.instance.collection("textcrud");
        reference.add(carData);
      });
    } else {
      print("You need to be logged in");
    }
  }

  getData() async {
    return await FirebaseFirestore.instance.collection("textcrud").snapshots();
  }


  updateData(selectedDoc, newValues) async{
    FirebaseFirestore.instance.collection("textcrud").doc(selectedDoc).update(newValues)
        .catchError((e){
          print(e);
    });
  }

  deleteData(selectedDoc) async{
    FirebaseFirestore.instance.collection("textcrud").doc(selectedDoc.toString()).delete()
        .catchError((e){
          print(e);
    });
  }
}