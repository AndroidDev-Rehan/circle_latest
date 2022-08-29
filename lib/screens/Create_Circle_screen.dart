
import 'package:circle/utils/data_repo.dart';
import 'package:circle/utils/db_operations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import '../widgets/dropdown_button.dart';
import 'add_contacts_circle.dart';
import 'chat_core/add_group_members.dart';
import 'login.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


class Circle {
  String? name;
  String? description;
  String? status;
  String? contact;
  String? refId;

  Circle({this.refId,required this.name , required this.description,required this.status, required this.contact});
  factory Circle.fromJson(Map<String,dynamic> json) => _circleFromJson(json);
  Map<String,dynamic> toJson() => _circleToJson(this);

  factory Circle.fromSnapshot(DocumentSnapshot snapshot) {
    final newCircle = Circle.fromJson(snapshot.data() as Map<String,dynamic>);
    newCircle.refId = snapshot.reference.id;
    return newCircle;
  }

  @override
  String toString() => 'Circle<$name>';
}

Circle _circleFromJson(Map<String,dynamic> json) {
  return Circle(name: json['name']  ?? "",
                description: json['description']  ?? "",
                status: json['status']  ?? "",
                contact: json['contact']  ?? "");
}
Map<String,dynamic> _circleToJson(Circle instance) =>
    <String,dynamic> {
       'name': instance.name,
       'description': instance.description,
       'status': instance.status,
        'contact': instance.contact,
    };

class CreateCirclePage extends StatefulWidget {
  final bool childCircle;
  final types.Room? parentRoom;
  const CreateCirclePage({Key? key, this.childCircle = false, this.parentRoom}) : super(key: key);
  @override
  State<CreateCirclePage> createState() => CreateCircleState();
}

class CreateCircleState extends State<CreateCirclePage>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;

  String? selectedStatus;

  final db = FirebaseFirestore.instance;
  final DataRepository repo = DataRepository();
  final textControllerName = TextEditingController();
  final textControllerDescription = TextEditingController();
  final textControllerStatus = TextEditingController();
  final textControllerContact = TextEditingController();


  // Future<void> createCircle() async {
  //
  //   repo.addCircle(Circle(name: textControllerName.text,
  //   description: textControllerDescription.text,
  //   status: textControllerDescription.text,
  //   contact: textControllerContact.text));
  //   Widget okButton = FlatButton(
  //     child: const Text("OK"),
  //     onPressed: () {
  //       Navigator.of(context, rootNavigator: true).pop('dialog');
  //       Navigator.of(context, rootNavigator: true).pop();
  //     },
  //   );
  //
  //   AlertDialog dialog =  AlertDialog(
  //     title: const Text("Circle Added"),
  //     actions: [okButton],
  //   );
  //   showDialog(context: context,
  //     builder: (BuildContext build) {
  //        return dialog;
  //     }
  //   );
  //
  // }

  @override
  Widget build(BuildContext context ) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Create Circle"),
          leading: IconButton(icon:const Icon(Icons.arrow_back),
          onPressed:()=> Navigator.pop(context,false),
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 10),
                          child: TextFormField(
                            controller: textControllerName,
                            decoration: const InputDecoration(
                              labelText: "Name:",
                              hintText: 'Name of Circle'
                            ),
                            validator: (String? value){
                              if(value == null || value.trim().isEmpty){
                                return "Name of Circle is required";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 10),
                          child: TextFormField(
                            controller: textControllerDescription,
                            decoration: const InputDecoration(
                              labelText: "Description",
                              hintText: " Description of Circle"
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 10),
                          child: MyDropDownButton(dropdownValue: null, function: (String v) { selectedStatus = v;  }, hintText: 'Select Status', items: const ['temporary','permanent'],  ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 4.0, vertical: 10),
                        //   child: TextFormField(
                        //     controller: textControllerStatus,
                        //     decoration: const InputDecoration(
                        //       hintText: "Temporary or Permanent",
                        //       labelText: "Status",
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 10),
                          child: TextFormField(
                            controller: textControllerContact,
                            decoration: const InputDecoration(
                              labelText: "Contact",
                              hintText: "Primary Contact Name"
                            ),
                          ),
                        ),
                      loading ? const SizedBox(
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )  : ElevatedButton(
                          onPressed: () async{
                            if (!widget.childCircle){
                                await createCircle(context);
                              }
                            else {
                              await createChildCircle(context);
                            }


                            }, child: const Text("Submit"))
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createCircle(BuildContext context) async{
    if(_formKey.currentState!.validate()){
      if(selectedStatus != null){
        setState(() {
          loading = true;
        });

        try {
          types.Room groupRoom = await FirebaseChatCore.instance
              .createGroupRoom(
                  name: textControllerName.text,
                  users: <types.User>[],
                  imageUrl:
                      "https://thumbs.dreamstime.com/b/linear-group-icon-customer-service-outline-collection-thin-line-vector-isolated-white-background-138644548.jpg",

                  ///TODO ADD CLOUD MESSAGING IDS of All Users of Rooms
                  metadata: {
                    "group": true,
                    'fcmTokens': [
                      await DBOperations.getDeviceTokenToSendNotification()
                    ],
                    'status': selectedStatus
                  });
          print(groupRoom.id);
          Get.off(() => AddContactsScreen(
                room: groupRoom,
              ));
        } catch (e) {
          Get.snackbar("Error", e.toString());
        }

        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      }
      else{
        Get.snackbar("Denied", "Select Circle Status");
      }
    }
  }

  Future<void> createChildCircle(BuildContext context) async{
    if(_formKey.currentState!.validate()){

      setState((){
        loading = true;
      });

      try {
        types.Room innerRoom = await FirebaseChatCore.instance.createGroupRoom(
            name: textControllerName.text,
            users: <types.User>[],
            imageUrl:
            "https://thumbs.dreamstime.com/b/linear-group-icon-customer-service-outline-collection-thin-line-vector-isolated-white-background-138644548.jpg",
            metadata: {
              "group": true,
              "isChildCircle" : true,
              // 'fcmTokens' : [await DBOperations.getDeviceTokenToSendNotification()]
            });

        Map map = widget.parentRoom!.metadata ?? {};

        List childCircles = map["childCircles"] ?? [];
        childCircles.add(innerRoom.id);

        map["childCircles"] = childCircles;

        ///TODO ADD FCM IDS

        await FirebaseFirestore.instance.collection("rooms").doc(widget.parentRoom!.id).update(
          {
            "metadata" : map
          }
        );

        print(innerRoom.id);

        // for (int i=0; i<widget.parentRoom!.users.length; i++){
        //   print(widget.parentRoom!.users[i].firstName);
        // }

        Get.off(
            AddMembersScreen(
              groupRoom: widget.parentRoom!,
              innerRoom: innerRoom,
            ));
      }
      catch(e){
        Get.snackbar("Error", e.toString());
      }

      if(mounted){
        setState(() {
          loading = false;
        });
      }

    }
  }
}