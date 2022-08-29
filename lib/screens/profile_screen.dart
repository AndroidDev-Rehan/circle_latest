import 'dart:io';
import 'package:circle/profileController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  ProfileController profileController = ProfileController();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    print(Get.width);
    double paddingRes30 = Get.width*0.070093;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Settings')),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: paddingRes30),
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (context,AsyncSnapshot<DocumentSnapshot<Map<String,dynamic>>> snapshot) {

            if(snapshot.data==null || snapshot.connectionState==ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }


            Map<String,dynamic> userMap = snapshot.data!.data()!;
            firstNameController.text = userMap['firstName'];
            lastNameController.text = userMap['lastName'];
            // passwordController.text = userMap['firstName'];
            // emailController.text = FirebaseAuth.instance.currentUser!.email;



            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  UserPhotoWidget(imageUrl: userMap['imageUrl'], profileController: profileController,),
                  SizedBox(height: Get.height* 0.0777 * 0.65,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: paddingRes30, vertical: 8),
                    child: _buildCustomTextField("First Name", readOnly: false, textEditingController: firstNameController),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: paddingRes30, vertical: 8),
                    child: _buildCustomTextField("Last Name", readOnly: false, textEditingController: lastNameController),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: paddingRes30, vertical: 8),
                  //   child: _buildCustomTextField("Password"),
                  // ),

                  ///TODO REPLACE EMAIL
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: paddingRes30, vertical: 8),
                    child: _buildCustomTextField("Email Address", readOnly: true, textEditingController: emailController),
                  ),
                  const SizedBox(height: 20,),
                  Obx(() => profileController.loading.value ? const SizedBox(height: 40, child: CircularProgressIndicator(),) : ElevatedButton(onPressed: () async{
                    profileController.saveInfo(firstName: firstNameController.text, lastName: lastNameController.text, imageUrl: userMap['imageUrl']);
                  }, child: const Text('Save'))),
                  const SizedBox(height: 20,),



                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildCustomTextField(String hintText, {bool readOnly = false, required TextEditingController textEditingController}){
    return TextFormField(
      controller: textEditingController,
      readOnly: readOnly,
      decoration:  InputDecoration(
        hintText: hintText,
        labelText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        border:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(30)
          // borderSide: const BorderSide(color: darkMain, ),
          // borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30)
          // borderSide: const BorderSide(color: darkMain, ),
          // borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(30)
          // borderSide: const BorderSide(color: darkMain, ),
          // borderRadius: BorderRadius.circular(30),
        ),
        disabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(30)
          // borderSide: const BorderSide(color: darkMain, ),
          // borderRadius: BorderRadius.circular(30),
        ),


        // isDense: true,
        filled: true,
        contentPadding: const EdgeInsets.only(top: 5, left: 25),
        fillColor: Colors.white,
      ),
      style: const TextStyle(
        color: Colors.black,

      ),
      cursorColor: Colors.black,
    );
  }


}

class UserPhotoWidget extends StatefulWidget {
  const UserPhotoWidget({Key? key, required this.imageUrl, required this.profileController}) : super(key: key);

  final String imageUrl;
  final ProfileController profileController;

  @override
  State<UserPhotoWidget> createState() => _UserPhotoWidgetState();
}

class _UserPhotoWidgetState extends State<UserPhotoWidget> {


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        await uploadPhotoId();
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: widget.profileController.pickedFile!=null ? Image.file(File(widget.profileController.pickedFile!.path, ), height: 200, width: 200, fit: BoxFit.cover) : Image.network(widget.imageUrl, height: 200, width: 200, fit: BoxFit.cover),
          ),
          Positioned(
              bottom: 0,
              right: 20,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(Icons.photo_camera)))
        ],
      ),
    );
  }

  uploadPhotoId()async{
    widget.profileController.pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 10);
    if(widget.profileController.pickedFile!=null){
      setState((){});
    }
  }

}

