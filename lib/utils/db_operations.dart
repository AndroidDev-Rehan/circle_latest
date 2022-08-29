import 'dart:convert';
import 'dart:ui';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class DBOperations{

  // static types.User? currentUser;
  static String? fcmToken;
  static NotificationSettings? settings;

  // static Future<AppUser?> getCurrentUser() async{
  //   try{
  //
  //     if(currentUser!=null){
  //       return currentUser;
  //     }
  //
  //     final DocumentSnapshot<Map<String,dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection(Collections.users).doc(FirebaseAuth.instance.currentUser!.uid).get();
  //     final Map<String,dynamic> map = documentSnapshot.data()!;
  //     currentUser = AppUser.fromMap(map);
  //     return currentUser;
  //   }
  //   catch(e){
  //     Get.snackbar("Error", e.toString());
  //     return null;
  //   }
  // }

  static Future<String> getDeviceTokenToSendNotification() async {

    if(fcmToken!=null){
      return fcmToken!;
    }

    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    final token = await fcm.getToken();
    fcmToken = token.toString();
    print("Token Value $fcmToken");
    return fcmToken!;
  }

  static sendNotification({required List registrationIds,required String text, required String title}) async{
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    Map body = {
      "registration_ids": registrationIds,
      "notification": {
        "body": text,
        "title": title,
        "android_channel_id": "circledevapp",
        "sound": true
      }
    };

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'key=AAAAR4XjWDc:APA91bF3QpiWkBOfdhIFhzVVrcyoqUWZWJ6J5m6XEaC8h2VLv0FciA1GtHTvQ4u4ZLLOMOjeFFdq-AHeBg34GUPiCJxeoD-ArFTUFHTd0QEGRWiFDeuB3MzFxLnKGaDfDasYeZzN2yim',
      },
      body: json.encode(body),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

  }


  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }


  static Future handleNotificationPermissions() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('permissions are not granted. requesting now');
      DBOperations.settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
  }
}