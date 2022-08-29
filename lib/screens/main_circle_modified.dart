import 'package:circle/logoutController.dart';
import 'package:circle/phone_login/phone_login.dart';
import 'package:circle/screens/chat_core/search_chat_screen.dart';
import 'package:circle/screens/chat_core/search_users.dart';
import 'package:circle/screens/chat_core/users.dart';
import 'package:circle/screens/profile_screen.dart';
import 'package:circle/screens/view_circle_page.dart';
import 'package:circle/userinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:circle/screens/Create_Circle_screen.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import '../notification_service/local_notification_service.dart';
import '../utils/db_operations.dart';
import 'chat_core/rooms.dart';
import 'chat_core/view_requests_page.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class MainCircle extends StatefulWidget {
  const MainCircle({Key? key}) : super(key: key);
  @override
  State<MainCircle> createState() => MainCircleState();
}

class MainCircleState extends State<MainCircle> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();


  int index = 0;
  @override
  State<MainCircle> createState() => MainCircleState();


  void viewMyCircles(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const viewCircle()),
    );
  }


  @override
  void initState() {
    super.initState();

    /// 1. This method call when app in terminated state and you get a notification
    /// when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          print(message.notification?.title);
          print(message.notification?.body);

          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    /// 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
          (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    /// 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }


  int _currentIndex = 0;

  LogOutController logOutController = LogOutController();

  Map<String, dynamic>? userMap;

  @override
  Widget build(BuildContext context) {

    print(FirebaseAuth.instance.currentUser!.uid);
    // print(FirebaseChatCore.instance.firebaseUser);

    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey1,
          drawer: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context,AsyncSnapshot<DocumentSnapshot<Map<String,dynamic>>> snapshot) {

              userMap = snapshot.data?.data();
              if(userMap!=null){
                CurrentUserInfo.userMap = userMap;
              }


              return Drawer(
                child: Container(
                  color: Colors.blue,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        padding: EdgeInsets.zero,
                        child: UserAccountsDrawerHeader(
                          margin: EdgeInsets.zero,
                          accountName: userMap==null ? Text('username') : Text("${   userMap!["firstName"]} ${userMap!["lastName"]}"),
                          accountEmail: Text(FirebaseAuth.instance.currentUser!.email ?? ""),
                          currentAccountPicture: userMap==null ? null :  CircleAvatar(
                            backgroundImage: NetworkImage(userMap!["imageUrl"]),
                          ) ,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.home,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Home",
                          textScaleFactor: 1.2,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: (){
                          Get.off(MainCircle());
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.search_circle_fill,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Search Circles",
                          textScaleFactor: 1.2,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: (){
                          Get.back();
                          Get.to(SearchChatScreen());
                        },

                      ),
                      ListTile(
                        leading: const Icon(
                          CupertinoIcons.search,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Search Users",
                          textScaleFactor: 1.2,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: (){
                          Get.back();
                          Get.to(SearchUsersScreen());
                        },

                      ),
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.add,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Create a Circle",
                          textScaleFactor: 1.2,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: (){
                          Get.back();
                          Get.to(CreateCirclePage());
                        },

                      ),
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.person_2,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Select Users",
                          textScaleFactor: 1.2,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: (){
                          Get.back();
                          Get.to(UsersPage());
                        },

                      ),
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.checkmark_circle,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Join A Circle",
                          textScaleFactor: 1.2,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () async{
                          Get.back();
                          await joinCircleById();
                          // Get.off(MainCircle());
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Log Out",
                          textScaleFactor: 1.2,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: ()async{
                          Get.back();
                          await logout();
                        },

                      )



                    ],
                  ),
                ),
              );
            }
          ),
          backgroundColor: Colors.lightBlue,
          appBar: AppBar(
            elevation: 10.0,
            shadowColor: Colors.white70,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
              ),
              side: BorderSide(width: 0.7),
            ),
            title: const Text(
              'Circle',
              style: TextStyle(
                  fontSize: 25.0, fontFamily: 'Lora', letterSpacing: 1.0),
            ),
            bottom: _bottom(),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Obx(() => (!logOutController.loading.value) ? IconButton(
                  // tooltip: 'Refresh',
                    icon: const Icon(
                      Icons.logout_outlined,
                      size: 25.0,
                    ),
                    onPressed: () async {
                      // print('Hiragino Kaku Gothic ProN');
                      await logout();
                    }) : SizedBox(
                  height: 25,
                    width: 25,
                  child: CircularProgressIndicator(),
                )),
              ),
              InkWell(
                onTap: () {
                  // print("Hiragino Kaku Gothic ProN");
                  Get.to(const SearchChatScreen());
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(
                    CupertinoIcons.search_circle,
                    size: 25.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                    tooltip: 'Refresh',
                    icon: const Icon(
                      CupertinoIcons.refresh_circled,
                      size: 25.0,
                    ),
                    onPressed: () async {
                      Get.offAll(()=>const MainCircle());
                      // print('Clicked Refresh in Main Window');
                    }),
              ),
            ],
          ),
          body: (_currentIndex == 0)
              ? const RoomsPage(
            secondVersion: true,
          )
              : SafeArea(
            top: false,
            bottom: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: <Widget>[
                    ElevatedButton(
                        child: const Text("View My Circles"),
                        onPressed: () {
                          Get.to(RoomsPage());
                          // viewMyCircles(context);
                        }),
                    ElevatedButton(
                        child: const Text("Create A Circle"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const CreateCirclePage()),
                          );
                        }),
                    ElevatedButton(
                        child: const Text("View Circle Invites"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const ViewRequestsPage()),
                          );
                        }),
                    // ElevatedButton(
                    //     child: const Text("Create Dynamic Link"),
                    //     onPressed: () async {
                    //       await DynamicLinkHelper.createDynamicLink("0934");
                    //     })
                  ],
                ),
                // const NavigationBarItem(label: "messaging",icon: CupertinoIcons.bubble_left_bubble_right,),
                // const NavigationBarItem(label: "home",icon: Icons.home,),
                // const NavigationBarItem(label: "setting",icon: Icons.settings,)
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.blue[600],
            onTap: (index) {
              print("hi");
              // setState(() {
              //   this.index = index;
              // });

              if(index == 1){
                Get.to(ProfileScreen());
                // _scaffoldKey1.currentState!.openDrawer();
              }

              else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoomsPage()),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(CupertinoIcons.home),
              ),
              BottomNavigationBarItem(
                label: 'Settings',
                icon: Icon(
                  Icons.group,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Chat',
                icon: Icon(
                  CupertinoIcons.chat_bubble,
                ),
              ),
            ],
          )),
    );
  }

  // _createDynamicLink() async {
  //   print("staring  ..");
  //   final dynamicLinkParams = DynamicLinkParameters(
  //     link: Uri.parse("https://circledev.page.link/circle/007"),
  //     uriPrefix: "https://circledev.page.link",
  //     androidParameters: const AndroidParameters(
  //         packageName: "com.example.circle", minimumVersion: 1),
  //     iosParameters: const IOSParameters(bundleId: "com.example.circle"),
  //     // longDynamicLink: Uri.parse("https://circledev.page.link/circle?id=120")
  //   );
  //
  //   final Uri dynamicLink =
  //       await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
  //   print(dynamicLink);
  //
  //   // final ShortDynamicLink shortenedLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
  //
  //   final PendingDynamicLinkData? x =
  //       await FirebaseDynamicLinks.instance.getDynamicLink(dynamicLink);
  //   final PendingDynamicLinkData? y = await FirebaseDynamicLinks.instance
  //       .getDynamicLink(Uri.parse("https://circledev.page.link/circles"));
  //   // final PendingDynamicLinkData? z = await FirebaseDynamicLinks.instance.getDynamicLink(shortenedLink.shortUrl);
  //
  //   // print(x);
  //   print(y);
  //   // print(z);
  //
  //   // print("short url : $z");
  //
  //   // return shortenedLink.shortUrl;
  // }

  Future<void> logout() async {
    print('hi');

    logOutController.loading.value = true;


    try {
      String fcmToken = await DBOperations.getDeviceTokenToSendNotification();
      // List<String> tokenList = [fcmToken];

      if(userMap==null){
        DocumentSnapshot<Map<String,dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
        userMap = documentSnapshot.data()! ;
      }

      Map metadata = userMap!['metadata'];

      List previousTokens = metadata['fcmTokens'];
      previousTokens.removeWhere((dynamic element){
        return element.toString() == fcmToken.toString();
      });

      metadata['fcmTokens'] = previousTokens;


      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(
          {"metadata": metadata
          });
    } catch (e) {
      print(e);
      rethrow;
    }

    await FirebaseAuth.instance.signOut();

    logOutController.loading.value = false;
    CurrentUserInfo.userMap = null;

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return PhoneLoginScreen();
    }));
  }
  
  Future<void> joinCircleById()async{
    {
      TextEditingController idController =
      TextEditingController();
      // Map? circleMap;
      types.Room? room;
      bool tried = false;
      await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Enter Circle Id'),
            content: TextFormField(
              controller: idController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () async {

                    if(idController.text.isEmpty){
                      Get.snackbar("Error", "Id cant be null");
                      return;
                    }

                    tried = true;
                    try{
                      room = await FirebaseChatCore.instance
                          .room(idController.text)
                          .first;
                    }
                    catch(e){
                      room = null;
                    }

                    Navigator.pop(context);
                  },
                  child: Text("Confirm"))
            ],
          ));

      bool alreadyJoined = false;

      if (room != null  ) {

        for (var element in room!.users) {
          if (element.id == FirebaseAuth.instance.currentUser!.uid){
            alreadyJoined = true;
            break;
          }
        }


        await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Join Circle'),
              content: Container(
                margin: const EdgeInsets.only(
                    right: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      // backgroundColor: hasImage ? Colors.transparent : color,
                      backgroundImage: NetworkImage(
                          room!.imageUrl ??  'https://media.istockphoto.com/vectors/user-avatar-profile-icon-black-vector-illustration-vector-id1209654046?k=20&m=1209654046&s=612x612&w=0&h=Atw7VdjWG8KgyST8AXXJdmBkzn0lvgqyWod9vTb2XoE='),
                      radius: 40,
                      child: null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                        room?.name ?? "room")
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                ElevatedButton(
                    onPressed: alreadyJoined ? null : () async {
                      try {
                        // await FirebaseFirestore.instance.collection("rooms")
                        //     .doc(widget.groupRoom.id)
                        //     .update({"users": userIds});
                        await FirebaseFirestore
                            .instance
                            .collection("rooms")
                            .doc(
                            idController.text)
                            .update({
                          "userIds": FieldValue
                              .arrayUnion([
                                FirebaseAuth.instance.currentUser!.uid
                          ])
                        });
                        Navigator.pop(context);
                        Get.snackbar("Success",
                            "you are added to ${room?.name ?? 'circle'}", backgroundColor: Colors.white);
                      } catch (e) {
                        Get.snackbar(
                            "error", e.toString());
                        print(e);
                      }
                    },
                    child: const Text("Join"))
              ],
            ));
      }
      else if (tried == true && room==null){
        Get.snackbar("Sorry", "No circle found", backgroundColor: Colors.white);
      }
    }
    
  }

  PreferredSizeWidget? _bottom() {
    return TabBar(
      indicatorPadding: EdgeInsets.only(left: 20.0, right: 20.0),
      labelColor: Colors.blueGrey,
      unselectedLabelColor: Colors.white70,
      indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 2.0, color: Colors.black87),
          insets: EdgeInsets.symmetric(horizontal: 15.0)),
      automaticIndicatorColorAdjustment: true,
      labelStyle: const TextStyle(
        fontFamily: 'Lora',
        fontWeight: FontWeight.w500,
        letterSpacing: 1.0,
      ),
      onTap: (index) {
        // print("\nIndex is:$index");
        if (mounted) {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      tabs: const [
        Tab(
          child: Text(
            'Chats',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Lora',
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Tab(
          child: Text(
            'Logs',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Lora',
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}

class NavigationBarItem extends StatelessWidget {
  const NavigationBarItem({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        // print('context');
      },
      child: SizedBox(
        height: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(
              height: 8,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
