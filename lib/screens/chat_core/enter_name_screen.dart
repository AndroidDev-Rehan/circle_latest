import 'package:circle/screens/join_group_info.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../main.dart';

class EnterNameScreen extends StatefulWidget {
  const EnterNameScreen({Key? key, required this.groupId}) : super(key: key);
  final String groupId;

  @override
  State<EnterNameScreen> createState() => _EnterNameScreenState();
}

class _EnterNameScreenState extends State<EnterNameScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _registering = false;

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _registering ? const CircularProgressIndicator() : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Enter Your name")),
                ),
                ElevatedButton(
                    onPressed: () async{
                      await _register(context);
                      // FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
                    },
                    child: const Text("Submit"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    FocusScope.of(context).unfocus();

    if(_formKey.currentState!.validate()){

      nameController.text = "${nameController.text} ";
      List<String> names = nameController.text.split(" ");
      print("name is $names");


      setState(() {
        _registering = true;
      });

      try {

        String email = Faker().internet.freeEmail();

        print(email);

        final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: "123456",
        );

        await FirebaseChatCore.instance.createUserInFirestore(
          types.User(
            firstName: names[0],
            id: credential.user!.uid,
            imageUrl:
            'https://i.pravatar.cc/300?u=${nameController.text}',
            lastName: (names.length>=2) ? names[1] : "",
          ),
        );

        if (!mounted) return;

        // if(FirebaseAuth.instance.currentUser!=null){
        //   await getUserMap(FirebaseAuth.instance.currentUser!.uid);
        // }


        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return JoinGroupInfo(groupId: widget.groupId);
        }));
      } catch (e) {
        setState(() {
          _registering = false;
        });

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
            content: Text(
              e.toString(),
            ),
            title: const Text('Error'),
          ),
        );
      }
    }
  }
}
