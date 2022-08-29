import 'package:circle/calendar_controller.dart';
import 'package:circle/models/event_model.dart';
import 'package:circle/screens/add_event_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widgets/event_tile.dart';

class CalendarListEventsScreen extends StatelessWidget {
  CalendarListEventsScreen({Key? key, required this.circleId})
      : super(key: key);

  final String circleId;

  final CalendarController calendarController = CalendarController();

  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Events",),centerTitle: true),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('events')
                .where('circleId', isEqualTo: circleId)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData &&
                  (!(snapshot.connectionState == ConnectionState.waiting))) {
                _markedDateMap.clear();
                List<EventModel> eventModelsList = snapshot.data!.docs
                    .map(
                        (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) =>
                        EventModel.fromMap(documentSnapshot.data()!))
                    .toList();
                for (var eventModel in eventModelsList) {
                  _markedDateMap.add(
                      DateTime.fromMillisecondsSinceEpoch(
                          eventModel.eventDate.millisecondsSinceEpoch),
                      Event(
                          date: DateTime.fromMillisecondsSinceEpoch(
                              eventModel.eventDate.millisecondsSinceEpoch),
                          dot: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1.0),
                            height: 5.0,
                            width: 5.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.purple),
                          )));
                }
              }

              return Column(
                children: [
                  Obx(() =>                 Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: CalendarCarousel<Event>(

                            pageScrollPhysics: NeverScrollableScrollPhysics(),
                            customGridViewPhysics: NeverScrollableScrollPhysics(),
                            // isScrollable: false,
                            selectedDateTime: calendarController.currentDateTime.value,
                            todayTextStyle: const TextStyle(color: Colors.black),
                            selectedDayButtonColor: Colors.blue.withOpacity(0.6),
                            todayButtonColor: Colors.blueGrey,
                            todayBorderColor: Colors.transparent,
                            onDayPressed: (DateTime date, List<Event> events) {
                              calendarController.currentDateTime.value = date;
                              print(calendarController.currentDateTime.value);
                              // fillEvents( DateTime(date.year,date.month,date.day));
                            },
                            markedDatesMap: _markedDateMap,
                            // markedDateIconMaxShown: 2,
                            // markedDateMoreShowTotal: true,
                            weekendTextStyle: const TextStyle(
                              color: Colors.black12,
                            ),
                            thisMonthDayBorderColor: Colors.grey,
                            daysHaveCircularBorder: false,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 1.0),
                                  height: 8.0,
                                  width: 8.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.purple),
                                ),
                                SizedBox(width: 5,),
                                Text("   Upcoming Events"),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text("Events scheduled for ${DateFormat("dd-MM-yyyy").format(calendarController.currentDateTime.value)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),

                    ],
                  )),
                  SizedBox(height: 20,),
                  (snapshot.connectionState == ConnectionState.waiting ||
                      (!(snapshot.hasData)))
                      ? Center(
                        child: Text("Loading Events .."),
                      )
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        ///TODO FIX THIS STREAM BUILDER

                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            EventModel eventModel = EventModel.fromMap(
                                snapshot.data!.docs[index].data());

                            return Obx(() => Container(
                              child: (DateFormat("dd/MM/yyyy").format(
                                  calendarController
                                      .currentDateTime.value)) ==
                                  DateFormat("dd/MM/yyyy").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          eventModel.eventDate
                                              .millisecondsSinceEpoch)) ? SingleEventTile(
                                eventModel: eventModel,
                              ) : const SizedBox(),
                            ));

                            // if () {
                            //   return SingleEventTile(
                            //     eventModel: eventModel,
                            //   );
                            // }
                            // print("returning size box");
                            // return const SizedBox();
                          })
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Get.to(AddEventScreen(circleId: circleId));
      },child: Icon(Icons.add)),
    );
  }
}
