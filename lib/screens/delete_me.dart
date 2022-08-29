// import 'package:circle/calendar_controller.dart';
// import 'package:circle/models/event_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
// import 'package:flutter_calendar_carousel/classes/event.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// import '../widgets/event_tile.dart';
//
//
//
// class CalendarListEventsScreen extends StatelessWidget {
//   CalendarListEventsScreen({Key? key, required this.circleId})
//       : super(key: key);
//
//   final String circleId;
//
//   final CalendarController calendarController = CalendarController();
//
//   final List<EventModel> eventModelsList = [];
//
//   final EventList<Event> _markedDateMap = EventList<Event>(
//     events: {},
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: getEvents(),
//         builder: (context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//
//           if(snapshot.hasData && (!(snapshot.connectionState==ConnectionState.waiting))){
//             for(int i=0; i<snapshot.data!.docs.length; i++){
//               snapshot.data!.docs[i].data();
//               for (int j=0; j < )
//             }
//           }
//
//           return Column(
//             children: [
//               Obx(() => SizedBox(
//                   height: MediaQuery.of(context).size.height / 1.9,
//                   child: CalendarCarousel<Event>(
//                     selectedDateTime: calendarController.currentDateTime.value,
//                     todayTextStyle: const TextStyle(color: Colors.black),
//                     selectedDayButtonColor: Colors.brown,
//                     todayButtonColor: Colors.blueGrey,
//                     todayBorderColor: Colors.transparent,
//                     onDayPressed: (DateTime date, List<Event> events) {
//                       calendarController.currentDateTime.value = date;
//                       print(calendarController.currentDateTime.value);
//                       // fillEvents( DateTime(date.year,date.month,date.day));
//                     },
//                     markedDatesMap: _markedDateMap,
//                     // markedDateIconMaxShown: 2,
//                     // markedDateMoreShowTotal: true,
//                     weekendTextStyle: const TextStyle(
//                       color: Colors.black12,
//                     ),
//                     thisMonthDayBorderColor: Colors.grey,
//                     daysHaveCircularBorder: false,
//                   ))),
//               (snapshot.connectionState == ConnectionState.waiting ||
//                   (!(snapshot.hasData)))
//                   ? const Expanded(
//                   child: Center(
//                     child: Text("Loading Events .."),
//                   ))
//                   : Obx(() => Expanded(
//                   child: ListView.builder(
//                     ///TODO FIX THIS STREAM BUILDER
//
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         EventModel eventModel = EventModel.fromMap(
//                             snapshot.data!.docs[index].data());
//                         if ((DateFormat("dd/mm/yyyy").format(
//                             calendarController
//                                 .currentDateTime.value)) ==
//                             DateFormat("dd/mm/yyyy").format(
//                                 DateTime.fromMillisecondsSinceEpoch(
//                                     eventModel.eventDate
//                                         .millisecondsSinceEpoch))) {
//                           return SingleEventTile(
//                             eventModel: eventModel,
//                           );
//                         }
//                         return const SizedBox();
//                       })))
//             ],
//           );
//         });
//   }
//
// // Future getEvents() async{
// //    DocumentSnapshot<Map> snapshot = await FirebaseFirestore.instance.collection("events").doc(circleId).get();
// //    Map map = snapshot.data()!;
// //    List eventDates = map['eventDates'];
// //
// //    for (int i=0; i<eventDates.length; i++){
// //      QuerySnapshot<Map> subCollection = await FirebaseFirestore.instance.collection("events").doc(circleId).collection(eventDates[i]).get();
// //
// //    }
// //
// // }
// }