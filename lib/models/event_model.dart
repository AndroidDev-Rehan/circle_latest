import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventModel{
  final String title;
  final String description;
  final Timestamp createdAt;
  final Timestamp eventDate;
  final int eventBestTimeInSeconds;
  final Map<String,dynamic> userIdsAndSuggestedTimes;
  final String eventId;
  final String circleId;

  const EventModel({
    required this.title,
    required this.description,
    required this.createdAt,
    required this.eventDate,
    required this.eventBestTimeInSeconds,
    required this.userIdsAndSuggestedTimes,
    required this.eventId,
    required this.circleId
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'eventDate': eventDate,
      'eventBestTimeInSeconds': eventBestTimeInSeconds,
      'userIdsAndSuggestedTimes': userIdsAndSuggestedTimes,
      'eventId': eventId,
      'circleId': circleId,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: map['createdAt'] as Timestamp,
      eventDate: map['eventDate'] as Timestamp,
      eventBestTimeInSeconds: map['eventBestTimeInSeconds'] as int,
      userIdsAndSuggestedTimes: map['userIdsAndSuggestedTimes'] as Map<String, dynamic>,
      eventId: map['eventId'] as String,
      circleId: map['circleId'],
    );
  }
}