import 'package:circle/screens/main_circle_modified.dart';
import 'package:circle/utils/db_operations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


class ProfileController extends GetxController{
  Rx<bool> loading = false.obs;
  XFile? pickedFile;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();


  Future<String> uploadImageAndGetUrl( ) async {
    String downloadUrl = '';
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("file ${DateTime.now()}");
    UploadTask uploadTask = ref.putFile(File(pickedFile!.path));
    await uploadTask.then((res) async{
      downloadUrl = await res.ref.getDownloadURL();
    });
    return downloadUrl;
  }

  Future<void> saveInfo({required String firstName, required String lastName, required String imageUrl , bool createIt = false }) async{
    loading.value = true;
    try{
      print("picked file is ${pickedFile?.path}");

      if(createIt){
        String fcmToken = await DBOperations.getDeviceTokenToSendNotification();
        List<String> tokenList = [fcmToken];
        await FirebaseChatCore.instance.createUserInFirestore(
          types.User(
            firstName: firstName,
            id: FirebaseAuth.instance.currentUser!.uid,
            imageUrl: (pickedFile != null) ? (await uploadImageAndGetUrl()) : imageUrl,
            lastName: lastName,
            metadata: {
              "fcmTokens":tokenList
            }
          ),
        );

        Get.to(const MainCircle());
      }

      else{
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'firstName': firstName,
          'lastName': lastName,
          'imageUrl':
              (pickedFile != null) ? (await uploadImageAndGetUrl()) : imageUrl
        });
        Get.back();
      }
      Get.snackbar("Success", "Info saved", backgroundColor: Colors.white);
    }
    catch(e){
      print(e);
      Get.snackbar("Error", e.toString());
    }
    loading.value = false;
  }

}