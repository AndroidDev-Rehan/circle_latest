import 'package:circle/utils/constants.dart';
import 'package:circle/widgets/request_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class CircleRepo{

  static Future<bool> addCurrentUserToCircle(types.Room room)async{

    final List<String> userIds = room.users.map((types.User user) => user.id).toList();
    userIds.add(FirebaseAuth.instance.currentUser!.uid);

    try {

      List<String> list = [];
      list.add(FirebaseAuth.instance.currentUser!.uid);


      ///TODO ADD FCM IDS
      await FirebaseFirestore.instance.collection("rooms")
          .doc(room.id)
          .update({"userIds": userIds});

      Get.snackbar("Success","Circle Joined",colorText: Colors.white);

      return true;
    }
    catch(e){
      print(e);
      Get.snackbar("Error",e.toString());
      return false;

    }
  }

}