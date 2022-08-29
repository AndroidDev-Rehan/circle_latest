import 'package:circle/phone_login/phone_login.dart';
import 'package:circle/screens/Create_Circle_screen.dart';
import 'package:circle/screens/chat_core/rooms.dart';
import 'package:circle/screens/users_for_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import '../login.dart';
import 'chat.dart';
import 'util.dart';

class ViewNestedRoom extends StatefulWidget {
  const ViewNestedRoom({Key? key, required this.user, required this.parentRoom}) : super(key: key);
  final User user;
  final types.Room parentRoom;

  @override
  State<ViewNestedRoom> createState() => _ViewNestedRoomState();
}

class _ViewNestedRoomState extends State<ViewNestedRoom> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: (true) ? AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          //   child: ElevatedButton(
          //       onPressed: _user == null
          //           ? null
          //           : () {
          //         Navigator.of(context).push(
          //           MaterialPageRoute(
          //             fullscreenDialog: true,
          //             builder: (context) =>  UsersForGroupList(),
          //           ),
          //         );
          //       },
          //       child: Text("New Group"),
          //     style: ElevatedButton.styleFrom(
          //       primary: Colors.lightBlue
          //     ),
          //   ),
          // )


        ],
        leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text('Circles'),

      ) : null,
      body: Column(
        children: [
          const SizedBox(height: 30,),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: ElevatedButton(
                child: const Text("Create an Inner Circle"),
                onPressed: (){

                  // for (int i=0; i<widget.parentRoom.users.length; i++){
                  //   print(widget.parentRoom.users[i].firstName);
                  // }


                  Get.to(
                      CreateCirclePage(
                        childCircle : true,
                        parentRoom: widget.parentRoom,
                      ));
                },
              ),
            ),
          ),
          const SizedBox(height: 30,),
          Expanded(
            child: StreamBuilder<List<types.Room>>(
              stream: FirebaseChatCore.instance.rooms(),
              initialData: const [],
              builder: (context,AsyncSnapshot<List<types.Room>> snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                      bottom: 200,
                    ),
                    child: const Text('No Inner Circles'),
                  );
                }

                print("metadata : ${widget.parentRoom.metadata}");
                List childCirclesList = widget.parentRoom.metadata?["childCircles"] ?? [];

                // List<String> ids = snapshot.data!.map((types.Room room) => room.id).toList();
                if((widget.parentRoom.metadata == null) || (widget.parentRoom.metadata!["childCircles"] == null) || (childCirclesList.isEmpty)){
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                      bottom: 200,
                    ),
                    child: const Text('No Inner Circles'),
                  );

                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final room = snapshot.data![index];

                    if (widget.parentRoom.metadata!=null){

                      List roomIds = widget.parentRoom.metadata!["childCircles"];

                      if(roomIds.contains(room.id)){
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  room: room,
                                  groupChat: room.type== types.RoomType.group,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _buildAvatar(room),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(room.name ?? 'no name', style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),),
                                        const SizedBox(height: 10,),
                                        FutureBuilder(
                                          future: fetchLastMsg(room),
                                          builder: (BuildContext context,AsyncSnapshot snapshot){
                                            if(snapshot.connectionState == ConnectionState.waiting){
                                              return const Text("Loading", style: TextStyle(color: Colors.white),);
                                            }

                                            return Text(snapshot.data!, style: TextStyle(color: Colors.white),);

                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        );

                      }
                    }

                    return SizedBox();

                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String> fetchLastMsg(types.Room room) async{
    try{
      final DocumentSnapshot<
          Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection("rooms").doc(room.id).get();
      final Map<String, dynamic> map = snapshot.data()!;
      globalRoomMap[room.id] = map["lastMsg"] ?? "chat ..." ;
      return map["lastMsg"] ?? "chat";
    }
    catch(e){
      return "Error";
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return PhoneLoginScreen();
    }));
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
              (u) => u.id != widget.user.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found.
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
        radius: 30,
        child: !hasImage
            ? Text(
          name.isEmpty ? '' : name[0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        )
            : null,
      ),
    );
  }
}
