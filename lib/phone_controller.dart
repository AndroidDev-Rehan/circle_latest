import 'dart:developer';

import 'package:circle/phone_login/collect_user_info.dart';
import 'package:circle/screens/main_circle_modified.dart';
import 'package:circle/utils/db_operations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PhoneController extends GetxController{

  TextEditingController otpcode=TextEditingController();
  Rx<String> smscode=''.obs;
  Rx<int?> token=0.obs;

  Rx<bool> loading = false.obs;


  String? phone;

  Future registerUserWithPhonenumber() async {
    log('hhhhhhhhhhhhhhhhhhhhhhhhhh');

    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phone!,
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential authCredential) async{
          loading.value = true;
          otpcode.text=authCredential.smsCode.toString();
          await verifyLoginOtp();
          loading.value = false;
        },
        verificationFailed: (FirebaseAuthException authException) {},
        codeSent: (String verificationId, int? forceResendingToken) {
          Get.snackbar("Success","OTP Sent", backgroundColor: Colors.white);
          // Toast.show("Otp Sent",backgroundColor: Colors.white, duration: Toast.lengthShort, gravity:  Toast.lengthLong);
          smscode.value = verificationId;
          token.value = forceResendingToken;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
        });
  }

  bool isValidEmail(String email) {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  Future<void> verifyLoginOtp() async{
    try{
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth
          .signInWithCredential(PhoneAuthProvider.credential(
          verificationId: smscode.value, smsCode: otpcode.text))
          .then((result) async {
        DocumentSnapshot<Map> documentSnapshot = await FirebaseFirestore
            .instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        Map? map = documentSnapshot.data();

        if (!documentSnapshot.exists) {

          // await FirebaseChatCore.instance.createUserInFirestore(
          //   types.User(
          //     firstName: _firstNameController!.text,
          //     id: credential.user!.uid,
          //     imageUrl:
          //     'https://i.pravatar.cc/300?u=${_usernameController!.text}',
          //     lastName: _lastNameController!.text,
          //   ),
          // );
          Get.offAll(CollectUserInfo(
             phoneNo: phone!,
          ));
        }
        else {

          Map metadata = map!['metadata'] ?? {};

          String fcmToken = await DBOperations.getDeviceTokenToSendNotification();

          if (metadata['fcmTokens'] == null){
            metadata['fcmTokens'] = [fcmToken];
          }
          else {
            List previousTokens = metadata['fcmTokens'];
            previousTokens.add(fcmToken);
            metadata['fcmTokens'] = previousTokens;
          }

          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update(
            {
              'metadata' : metadata
            }
          );

          Get.offAll(const MainCircle());
        }
        // Get.snackbar("Success", "Login");
        // print(user);
      });
    }
    on FirebaseAuthException catch (e) {
      Get.snackbar("OTP ISSUE ",e.message.toString());
      print(e.message);
    }
    catch(e){
      {
        print(e.runtimeType);
        // if(e.toString().contains(RegExp('expire'))){
        //   return;
        // }
        Get.snackbar('Some Error Occured', e.toString(),        backgroundColor: Colors.white
        );
      }
    }
  }


}