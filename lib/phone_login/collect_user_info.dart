import 'package:circle/profileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/profile_screen.dart';

class CollectUserInfo extends StatelessWidget {
  CollectUserInfo({Key? key, required this.phoneNo}) : super(key: key);

  final String phoneNo;
  final ProfileController profileController = ProfileController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(Get.width);
    double paddingRes30 = Get.width * 0.070093;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Settings')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingRes30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                UserPhotoWidget(
                  imageUrl: "https://i.pravatar.cc/300?u=$phoneNo",
                  profileController: profileController,
                ),
                SizedBox(
                  height: Get.height * 0.0777 * 0.65,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingRes30, vertical: 8),
                  child: _buildCustomTextField("First Name",
                      readOnly: false,
                      textEditingController: profileController
                          .firstNameController, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field is required";
                    }
                  }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingRes30, vertical: 8),
                  child: _buildCustomTextField("Last Name",
                      readOnly: false,
                      textEditingController: profileController
                          .lastNameController, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field is required";
                    }
                  }),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: paddingRes30, vertical: 8),
                //   child: _buildCustomTextField("Password"),
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: paddingRes30, vertical: 8),
                //   child: _buildCustomTextField("Email Address", readOnly: true, textEditingController: emailController),
                // ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => profileController.loading.value
                    ? const SizedBox(
                        height: 40,
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await profileController.saveInfo(
                                firstName:
                                    profileController.firstNameController.text,
                                lastName:
                                    profileController.lastNameController.text,
                                imageUrl:
                                    "https://i.pravatar.cc/300?u=$phoneNo",
                                createIt: true);
                          }
                        },
                        child: const Text('Save'))),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField(String hintText,
      {bool readOnly = false,
      required TextEditingController textEditingController,
      required FormFieldValidator<String>? validator}) {
    return TextFormField(
      validator: validator,
      controller: textEditingController,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)
            // borderSide: const BorderSide(color: darkMain, ),
            // borderRadius: BorderRadius.circular(30),
            ),
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(30)
                // borderSide: const BorderSide(color: darkMain, ),
                // borderRadius: BorderRadius.circular(30),
                ),
        focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(30)
                // borderSide: const BorderSide(color: darkMain, ),
                // borderRadius: BorderRadius.circular(30),
                ),
        disabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(30)
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
