import 'package:circle/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key, required this.circleId}) : super(key: key);
  final String circleId;

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController eventTimeController = TextEditingController();



  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Event"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Form(
              key: _globalKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if ((value == null) || (value.isEmpty)) {
                        return "field is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Event Title",
                      hintText: "Event Title",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: descController,
                    validator: (value) {
                      if ((value == null) || (value.isEmpty)) {
                        return "field is required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Event Description",
                      hintText: "Event Description",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: eventDateController,
                    onTap: () async {
                      selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2025));
                      if (selectedDate != null) {
                        eventDateController.text = DateFormat("dd-MM-yyyy").format(selectedDate!).toString();
                        // setState(() {});
                      }
                    },

                    validator: (value) {
                      if (selectedDate == null) {
                        return "field is required";
                      }
                      return null;
                    },

                    decoration: const InputDecoration(
                      labelText: "Event Date",
                      hintText: "Event Date",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      disabledBorder: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                    ),
                    maxLines: 1,
                    readOnly: true,
                    // enabled: false,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (selectedTime == null) {
                        return "field is required";
                      }
                      return null;
                    },
                    controller: eventTimeController,
                    onTap: () async {
                      selectedTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (selectedTime != null) {
                        eventTimeController.text = "${selectedTime!.hour} : ${selectedTime!.minute}";
                        // setState(() {});
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Event Time",
                      hintText: "Event Time",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      disabledBorder: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                    ),
                    maxLines: 1,
                    readOnly: true,
                    // enabled: false,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  loading ? const SizedBox(height: 50, child: Center(child: CircularProgressIndicator(),),):
                  ElevatedButton(
                      onPressed: () async{
                        if (_globalKey.currentState!.validate()) {
                          setState((){
                            loading = true;
                          });
                          await _addEvent();
                          Get.back();
                          setState((){
                            loading = false;
                          });

                        }
                      },
                      child: const Text("Add Event"))
                ],
              )),
        ),
      ),
    );
  }

  _addEvent()async{
    try{
      String eventId = const Uuid().v4();
      EventModel eventModel = EventModel(title: titleController.text, description: descController.text, createdAt: Timestamp.now(), eventDate: Timestamp.fromMillisecondsSinceEpoch(selectedDate!.millisecondsSinceEpoch), eventBestTimeInSeconds: getNoOfSeconds(selectedTime!), userIdsAndSuggestedTimes: { FirebaseAuth.instance.currentUser!.uid : getNoOfSeconds(selectedTime!) }, eventId: eventId, circleId: widget.circleId);
      String subCollectionName = DateFormat("dd-MM-yyyy").format(selectedDate!);
      await FirebaseFirestore.instance.collection("events").doc(eventId).set(eventModel.toMap());
    }
    catch(e){
      Get.snackbar("error",e.toString());
      rethrow;
      print(e);
    }

  }

  int getNoOfSeconds(TimeOfDay timeOfDay){
    return ((timeOfDay.hour*60*60) + (timeOfDay.minute*60));
  }
}
