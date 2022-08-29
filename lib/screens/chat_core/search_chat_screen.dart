import 'package:circle/search_filter_controller.dart';
import 'package:circle/widgets/single_chat_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';

class SearchChatScreen extends StatefulWidget {
  const SearchChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchChatScreen> createState() => _SearchChatScreenState();
}

class _SearchChatScreenState extends State<SearchChatScreen> {
  TextEditingController searchController = TextEditingController();
  SearchFilterController searchFilterController = Get.put(SearchFilterController());

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Search Circles"),
            ),
            backgroundColor: Colors.lightBlue,
            body: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: searchController,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            label: Text(
                              "Search",
                              style: TextStyle(color: Colors.white),
                            ),
                            isDense: true),
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => CheckBoxWidget(text: "Circles Only", onTap: (){
                            searchFilterController.circlesOnly.value = !searchFilterController.circlesOnly.value;
                          }, value: searchFilterController.circlesOnly.value)),

                          Obx(() => CheckBoxWidget(text: "Users Only", onTap: (){
                            searchFilterController.usersOnly.value = !searchFilterController.usersOnly.value;
                          }, value: searchFilterController.usersOnly.value)),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: StreamBuilder<List<types.Room>>(
                    stream: FirebaseChatCore.instance.rooms(),
                    initialData: const [],
                    builder:
                        (context, AsyncSnapshot<List<types.Room>> snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                            bottom: 200,
                          ),
                          child: const Text('No circles'),
                        );
                      }

                      print(snapshot.data!);

                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final types.Room room = snapshot.data![index];

                          String? otherUserName;

                          if (room.type == types.RoomType.direct) {
                            for (int i = 0; i < room.users.length; i++) {
                              if (room.users[i].id !=
                                  FirebaseAuth.instance.currentUser!.uid) {
                                otherUserName =
                                    ("${room.users[i].firstName} ${room.users[i].lastName}");
                              }
                            }
                          }

                          if((room.metadata == null) || (room.metadata!["isChildCircle"] == null) || (room.metadata!["isChildCircle"] == false)){
                            if (searchController.text.isEmpty ||
                                (room.name?.toLowerCase().startsWith(RegExp(
                                        searchController.text
                                            .toLowerCase()
                                            .trim())) ??
                                    false) ||
                                (otherUserName?.toLowerCase().startsWith(RegExp(
                                        searchController.text
                                            .toLowerCase()
                                            .trim())) ??
                                    false)) {
                              return Obx(() => Container(
                                  child: ((!searchFilterController
                                              .circlesOnly.value) &&
                                          (!searchFilterController
                                              .usersOnly.value))
                                      ? SingleChatTile(room: room)
                                      : (((searchFilterController
                                                      .circlesOnly.value &&
                                                  room.type ==
                                                      types.RoomType.group) ||
                                              ((!searchFilterController
                                                      .circlesOnly.value) &&
                                                  (!(room.type ==
                                                      types.RoomType.group))))
                                          ? SingleChatTile(room: room)
                                          : const SizedBox())));
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
          ),
        ),
      );
}

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({Key? key, required this.text, required this.onTap, required this.value}) : super(key: key);
  final String text;
  final Function onTap;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
            onTap: (){
              onTap();
            },
            child: Icon(value ? Icons.check_box : Icons.check_box_outline_blank, color: Colors.white,)),
        const SizedBox(width: 5,),
        Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
      ],
    );
  }
}