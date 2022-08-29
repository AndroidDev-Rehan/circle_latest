import 'package:circle/phone_login/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/main_circle_modified.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({Key? key}) : super(key: key);

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {

  final TextEditingController _texFieldController = TextEditingController();
  // final TextEditingController _texFieldController2 = TextEditingController();


  void showAlert(BuildContext context, String content) {
    Widget okButton = FlatButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    AlertDialog dialog = AlertDialog(
        title: const Text('Alert Dialog'),
        actions: [ okButton,],
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Error: $content'),
            ],
          ),
        )
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Text("Login"),
            SizedBox(height: 10,),
            Image.asset("assets/images/Circle.jpg", width: 400, height: 80),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 9, vertical: 16),
              child: TextFormField(
                controller: _texFieldController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your phoneNo',
                ),
              ),
            ),
            const SizedBox(
              width: 300,
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 300,
                child:
                ElevatedButton(
                  onPressed: () async{

                    Get.off(OtpScreen(phoneno: _texFieldController.text.contains("+") ? _texFieldController.text : "+${_texFieldController.text}"));

                    // Future<String?> user  = FireAuth.signInUsingEmailPassword(email: _texFieldController.text, password: _texFieldController2.text, context:context);

                    // if(FirebaseAuth.instance.currentUser!=null){
                    //   await getUserMap(FirebaseAuth.instance.currentUser!.uid);
                    // }


                    // user.then((value) => {
                    //   if(value == null)
                    //     {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder:(context) => const MainCircle()),
                    //       ),
                    //     }else {
                    //     showAlert(context,value),
                    //   }
                    // },onError: (err){
                    //   showAlert(context,err);
                    // });
                  },
                  child: const Text("Send OTP"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
