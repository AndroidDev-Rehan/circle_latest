import 'package:circle/screens/Create_Circle_screen.dart';
import 'package:circle/screens/chat_core/add_group_members.dart';
import 'package:circle/screens/chat_core/chat.dart';
import 'package:circle/screens/main_circle_modified.dart';
import 'package:circle/utils/circle_repo.dart';
import 'package:circle/utils/dynamiclink_helper.dart';
import 'package:circle/utils/join_circle_controller.dart';
import 'package:circle/widgets/single_user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import 'chat_core/no_group_found.dart';

class JoinGroupInfo extends StatefulWidget {
  final String groupId;
  const JoinGroupInfo({Key? key, required this.groupId}) : super(key: key);

  @override
  State<JoinGroupInfo> createState() => _JoinGroupInfoState();
}

class _JoinGroupInfoState extends State<JoinGroupInfo> {
  TextEditingController groupNameController = TextEditingController();
  types.User? currentUser;

  types.Room? room;
  // bool loading = false;
  bool alreadyJoined = false;
  JoinCircleController joinCircleController = JoinCircleController();

  @override
  Widget build(BuildContext context) {
    print(widget.groupId);
    return FutureBuilder(
        future: generateRoom(widget.groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Circle Info"),
                  centerTitle: true,
                ),
              body: Center(
                child: Text("Loading info .."),
              ),
            );
          }

          return Scaffold(
              appBar: AppBar(
                title: const Text("Circle Info"),
                centerTitle: true,
              ),
              body: (room==null) ? const NoGroupFound() : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          room!.imageUrl ??
                              "https://media.istockphoto.com/vectors/user-avatar-profile-icon-black-vector-illustration-vector-id1209654046?k=20&m=1209654046&s=612x612&w=0&h=Atw7VdjWG8KgyST8AXXJdmBkzn0lvgqyWod9vTb2XoE=",
                          width: 100,
                          height: 100,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: groupNameController,
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Circle name can't be empty";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text(
                          "Circle Name",
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        isDense: true,
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: StreamBuilder<types.Room>(
                        stream: FirebaseChatCore.instance.room(widget.groupId),
                        initialData: room,
                        builder: (context,AsyncSnapshot<types.Room> snapshot) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      (snapshot.data==null) ?
                                      "${room!.users.length} Participants" :
                                      "${snapshot.data!.users.length} Participants"

                                      ,
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // Text(groupRoom.name!,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                              Expanded(
                                  child:
                          (snapshot.data == null) ?
                                  ListView.builder(
                                      itemCount: room!.users.length,
                                      itemBuilder: (context, index) {
                                        types.User user = room!.users[index];
                                        return SingleUserTile(
                                            user: user, groupRoom: room!, hideDelete: true,
                                        );
                                      })
                              :                                   ListView.builder(
                              itemCount: snapshot.data!.users.length,
                              itemBuilder: (context, index) {
                                types.User user = snapshot.data!.users[index];
                                return SingleUserTile(
                                  user: user, groupRoom: snapshot.data!, hideDelete: true,
                                );
                              })


                              ),
                            ],
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Obx(()=>joinCircleController.loading.value
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            child:  Text((alreadyJoined || joinCircleController.joinedNow.value) ? "Go to Home Screen" : "Join Circle"),
                            onPressed:  () async {
                              if((alreadyJoined || joinCircleController.joinedNow.value)){
                                Get.off(const MainCircle());
                              }
                              else{
                                ///let user join group
                                joinCircleController.loading.value = true;
                                bool result = await CircleRepo.addCurrentUserToCircle(room!);
                                joinCircleController.loading.value = false;
                                if(result){
                                  // Get.off(ChatPage(room: room!));

                                  joinCircleController.joinedNow.value = result;

                                }
                                else
                                {
                                  Get.off(MainCircle());
                                }
                                // joinCircleController.joinedNow.value = result;



                                // Get.off(const MainCircle());

                              }

                            },
                          ),
                          // alreadyJoined ?
                          // ElevatedButton(
                          //   child:  Text("     Go to Home     "),
                          //   onPressed: () async {},
                          // ) : SizedBox()
                        ],
                      ),
                    )));
        });
  }

  Future<void> generateRoom(String id) async {
    if(room==null){
      try {
        Stream<types.Room> roomStream = FirebaseChatCore.instance.room(id);
        room = await roomStream.first;
        groupNameController.text = room?.name ?? "";

        if (room != null) {
          List<String> userIds =
              room!.users.map((types.User user) => user.id).toList();
          if (userIds.contains(FirebaseAuth.instance.currentUser!.uid)) {
            alreadyJoined = true;
          }
        }
      } catch (e) {
        room = null;
      }
    }
  }
}
