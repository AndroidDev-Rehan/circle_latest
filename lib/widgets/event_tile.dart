import 'package:circle/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleEventTile extends StatelessWidget {
  const SingleEventTile({Key? key, required this.eventModel}) : super(key: key);
  final EventModel eventModel;

  @override
  Widget build(BuildContext context) {
    print(Duration(seconds: eventModel.eventBestTimeInSeconds).toString().length);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Material(
        elevation: 2,
        child: ListTile(
          leading: SizedBox(
            width: 30,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1.0),
                height: 20.0,
                width: 20.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.purple),
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(eventModel.title, style: const TextStyle(fontWeight: FontWeight.bold),),
          ),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(eventModel.description),
              SizedBox(height: 10,),
              Row(
                children: [
                  const Text("Event Timing : ", style: TextStyle(fontStyle: FontStyle.italic),),
                  Text(Duration(seconds: eventModel.eventBestTimeInSeconds).toString().substring(0, (Duration(seconds: eventModel.eventBestTimeInSeconds).toString().length > 14) ? 5 : 4), style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
