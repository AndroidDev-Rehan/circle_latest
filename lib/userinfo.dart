import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUserInfo{
  static Map? userMap;

 static Future<Map> getCurrentUserMap() async{
    if(userMap == null){
     DocumentSnapshot<Map> documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
     userMap = documentSnapshot.data()!;
    }

    return userMap!;
  }
}