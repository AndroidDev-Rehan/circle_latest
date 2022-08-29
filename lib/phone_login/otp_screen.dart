import 'package:circle/phone_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../widgets/custom_button.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key? key,required this.phoneno, this.back = false, this.id}) : super(key: key);
  String phoneno;
  bool back;
  String? id;


  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  PhoneController phoneController = PhoneController();

  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  FocusNode focusNode3 = new FocusNode();
  FocusNode focusNode4 = new FocusNode();
  FocusNode focusNode5 = new FocusNode();
  @override
  void initState() {
    phoneController.phone = widget.phoneno;
    phoneController.registerUserWithPhonenumber();
    // TODO: implement initState
    super.initState();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        // color: darkMain,
        height: Get.height,
        width: Get.width,
        padding: EdgeInsets.all(15),
        child: loading ? Center(child: CircularProgressIndicator()) : Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40,),
            const SizedBox(height: 100,),
            const Text(
              'Enter the code',
              style: TextStyle(
                  // color: mainGolden,
                  fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30,),
            Text('Enter the 4 digit code that we just sent to ${widget.phoneno}', style: TextStyle(fontSize: 18),),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: PinCodeTextField(
                controller: phoneController.otpcode,


                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  disabledColor: Colors.white,
                  inactiveColor: Colors.white,
                  activeColor: Colors.white,
                  selectedFillColor: Colors.white,
                  errorBorderColor: Colors.black,
                  inactiveFillColor: Colors.white,
                  selectedColor: Colors.black,

                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeFillColor: Colors.white,
                  borderWidth: 1,
                ),
                animationDuration: Duration(milliseconds: 300),
                enableActiveFill: true,
                onCompleted: (v) {
                  print("Completed");
                },
                onChanged: (value) {

                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                }, appContext: context,
              ),
            ),
            SizedBox(height: 30,),
          Obx(() =>             Center(
            child: phoneController.loading.value ? SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator()) :
            ElevatedButton(
              onPressed: () async{
              // print("hi");
              phoneController.loading.value = true;
              await phoneController.verifyLoginOtp();
              phoneController.loading.value = false;
            }, child: Text("Verify", style: TextStyle(fontSize: 18),),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(Get.width*0.7, 40)
              ),

            ),
          )),
          ],
        ),
      ),
    );
  }
}